module Ordering
  module Commands
    class AddOrder < Command
      attribute :order_id, Types::ID
      attribute :name, Types::OrderName

      alias :aggregate_id :order_id
    end
  end
end
