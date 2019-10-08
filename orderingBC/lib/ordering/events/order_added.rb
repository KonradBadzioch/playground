module Ordering
  module Events
    class OrderAdded < Event
      attribute :order_id, Types::ID
      attribute :name, Types::OrderName
    end
  end
end
