module QualityControl
  module Events
    class AuditAdded < Event
      attribute :audit_id, Types::UUID
    end
  end
end
