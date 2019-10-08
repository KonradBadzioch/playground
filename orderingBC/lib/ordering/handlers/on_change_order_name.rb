module Ordering
  module Handlers
    class OnChangeOrderName
      include CommandHandler

      def call(cmd)
        with_aggregate(Order, cmd.aggregate_id) do |order|
          order.change_name(cmd.name)
        end
      end
    end
  end
end
