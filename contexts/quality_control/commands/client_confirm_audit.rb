module QualityControl
  module Commands
    class ClientConfirmAudit < Command
      attribute :audit_id, Types::UUID

      alias :aggregate_id :audit_id
    end
  end
end
