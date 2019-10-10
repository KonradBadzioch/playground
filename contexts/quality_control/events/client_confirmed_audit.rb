module QualityControl
  module Events
    class ClientConfirmedAudit < Event
      attribute :audit_id, Types::UUID
    end
  end
end
