module QualityControl
  module Commands
    class EvaluateAudit < Command
      attribute :audit_id, Types::UUID
      attribute :evaluation, Types::Integer

      alias :aggregate_id :audit_id
    end
  end
end
