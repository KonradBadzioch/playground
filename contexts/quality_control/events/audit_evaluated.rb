module QualityControl
  module Events
    class AuditEvaluated < Event
      attribute :audit_id, Types::UUID
      attribute :evaluation, Types::Integer
    end
  end
end
