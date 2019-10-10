module QualityControl
  module Events
    class CommissionConfirmedAudit < Event
      attribute :audit_id, Types::UUID
    end
  end
end
