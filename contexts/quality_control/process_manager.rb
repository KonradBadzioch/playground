module QualityControl
  class ProcessManager
    class State
      attr_reader :evaluation, :commission_confirmed, :client_confirmed

      def apply_commission_confirmed_audit
        self.commission_confirmed = true
      end

      def apply_client_confirmed_audit
        self.client_confirmed = true
      end

      def apply_evaluation(event)
        self.evaluation = event.data[:evaluation]
      end

      def complete?
        commission_confirmed && client_confirmed && evaluation.present?
      end

      def apply(*events)
        events.each do |event|
          case event
          when Events::AuditEvaluated then apply_evaluation(event)
          when Events::CommissionConfirmedAudit then apply_commission_confirmed_audit
          when Events::ClientConfirmedAudit then apply_client_confirmed_audit
          end
          @event_ids_to_link << event.event_id
        end
      end

      def load(stream_name:, event_store:)
        events = event_store.read.stream(stream_name).forward.to_a
        events.each { |event| apply(event) }
        @version = events.size - 1
        @event_ids_to_link = []
        self
      end

      def store(stream_name:, event_store:)
        event_store.link(
          event_ids_to_link,
          stream_name: stream_name,
          expected_version: version
        )
        @version += event_ids_to_link.size
        @event_ids_to_link = []
      end

      private

      attr_accessor :version, :event_ids_to_link
      attr_writer :evaluation, :commission_confirmed, :client_confirmed

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

    def event_store
      Rails.configuration.event_store
    end

    def command_bus
      Rails.configuration.command_bus
    end
  end
end
