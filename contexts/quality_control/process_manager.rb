module QualityControl
  class ProcessManager
    class State
      def apply_commission_confirmed_audit
        commission_confirmed = true
      end

      def apply_client_confirmed_audit
        client_confirmed = true
      end

      def apply_evaluation#(grade)
        evaluation = 0 #grade
      end

      def complete?
        commission_confirmed && client_confirmed && evaluation.present?
      end

      def apply(*events)
        events.each do |event|
          case event
          when QualityControl::Events::AuditEvaluated then apply_evaluation
          when QualityControl::Events::CommissionConfirmedAudit then apply_commission_confirmed_audit
          when QualityControl::Events::ClientConfirmedAudit then apply_client_confirmed_audit
          end
          event_ids_to_link << event.id
        end
      end

      def load(stream_name:, event_store:)
        events = event_store.read_stream_events_forward(stream_name)
        events.each { |event| apply(event) }
        version = events.size - 1
        event_ids_to_link = []
        self
      end

      def store(stream_name:, event_store:)
        event_store.link_to_stream(
          event_ids_to_link,
          stream_name: stream_name,
          expected_version: version
        )
        version = event_ids_to_link.size
        event_ids_to_link = []
      end

      private

      attr_accessor :version, :evaluation, :commission_confirmed, :client_confirmed
      attr_reader :event_ids_to_link

      def initialize
        @commission_confirmed = false
        @client_confirmed = false
        @version = -1
        @event_ids_to_link = []
      end
    end

    def call(event)
      audit_id = event.data[:audit_id]
      stream_name = "Audit$#{audit_id}"

      state = State.new
      state.load(stream_name: stream_name, event_store: event_store)
      state.apply(event)
      state.store(stream_name: stream_name, event_store: event_store)

      command_bus.call(
        CompleteAudit.new(
          data: {
            audit_id: audit_id
          }
        )
      ) if state.complete?
    end

    private

    attr_reader :command_bus, :event_store

    def initialize(command_bus:, event_store:)
      @command_bus = command_bus
      @event_store = event_store
    end
  end
end
