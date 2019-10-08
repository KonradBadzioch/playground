module Ordering
  module Handlers
    class OnOrderAdded
      include CommandHandler

      def call(cmd)
        with_aggregate(Ordering::Order, cmd.aggregate_id) do |order|
          order.create(cmd.name)
        end
      end
    end
  end
end
