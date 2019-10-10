module QualityControl
  module Commands
    class CommissionConfirmAudit < Command
      attribute :audit_id, Types::UUID

      alias :aggregate_id :audit_id
    end
  end
end
