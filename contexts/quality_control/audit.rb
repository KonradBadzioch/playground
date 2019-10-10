require 'aggregate_root'

module QualityControl
  class Audit
    include AggregateRoot

    def add
      apply Events::AuditAdded.new(data: { audit_id: id })
    end

    def client_confirm
      apply Events::ClientConfirmedAudit.new(data: { audit_id: id })
    end

    def commission_confirm
      apply Events::CommissionConfirmedAudit.new(data: { audit_id: id })
    end

    def evaluate(evaluation)
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
  end
end

# command_bus = Rails.configuration.command_bus
# cmd = QualityControl::Commands::AddAudit.new
# cmd = QualityControl::Commands::ClientConfirmAudit.new(audit_id: "782664b5-4e2e-409f-8d19-42ae0dd68626")
# cmd = QualityControl::Commands:CommissionConfirmAudit.new(audit_id: "c45e13ac-30ae-42b9-958e-bb8a7caa2677")
# command_bus.call(cmd)