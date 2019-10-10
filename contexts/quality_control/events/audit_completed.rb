module QualityControl
  module Events
    class AuditCompleted < Event
      attribute :audit_id, Types::UUID
    end
  end
end
