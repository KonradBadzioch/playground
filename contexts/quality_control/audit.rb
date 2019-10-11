require 'aggregate_root'

module QualityControl
  class Audit
    include AggregateRoot

    AlreadyConfirmedByClient = Class.new(StandardError)
    AlreadyConfirmedByCommission = Class.new(StandardError)
    AlreadyEvaluated = Class.new(StandardError)

    def add
      apply Events::AuditAdded.new(data: { audit_id: id })
    end

    def client_confirm
      raise AlreadyConfirmedByClient if event_store.read.stream(stream_name).to_a.any? { |event| event.class == Events::ClientConfirmedAudit }
      apply Events::ClientConfirmedAudit.new(data: { audit_id: id })
    end

    def commission_confirm
      raise AlreadyConfirmedByCommission if event_store.read.stream(stream_name).to_a.any? { |event| event.class == Events::CommissionConfirmedAudit }
      apply Events::CommissionConfirmedAudit.new(data: { audit_id: id })
    end

    def evaluate(evaluation)
      raise AlreadyEvaluated if event_store.read.stream(stream_name).to_a.any? { |event| event.class == Events::AuditEvaluated }
      apply Events::AuditEvaluated.new(data: { audit_id: id, evaluation: evaluation })
    end

    private

    attr_reader :id

    def initialize(audit_id)
      @id = audit_id
    end

    on Events::AuditAdded do |event|
    end

    on Events::AuditEvaluated do |event|
    end

    on Events::ClientConfirmedAudit do |event|
    end

    on Events::CommissionConfirmedAudit do |event|
    end

    def event_store
      Rails.configuration.event_store
    end

    def stream_name
      "Audit$#{id}"
    end
  end
end

# command_bus = Rails.configuration.command_bus
# cmd = QualityControl::Commands::AddAudit.new
# cmd = QualityControl::Commands::ClientConfirmAudit.new(audit_id: "8a6e0559-ae4c-46c0-a5e5-37320eb7186d")
# cmd = QualityControl::Commands::CommissionConfirmAudit.new(audit_id: "8a6e0559-ae4c-46c0-a5e5-37320eb7186d")
# cmd = QualityControl::Commands::EvaluateAudit.new(audit_id: "8a6e0559-ae4c-46c0-a5e5-37320eb7186d", evaluation: 5)
# command_bus.call(cmd)

# RailsEventStoreActiveRecord::Event.destroy_all; RailsEventStoreActiveRecord::EventInStream.destroy_all