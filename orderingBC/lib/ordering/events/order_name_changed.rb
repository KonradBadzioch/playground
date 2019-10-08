module Ordering
  module Events
    class OrderNameChanged < Event
      attribute :order_id, Types::ID
      attribute :name, Types::OrderName
    end
  end
end
