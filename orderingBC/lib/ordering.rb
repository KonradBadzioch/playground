module Ordering
end

require_dependency 'ordering/order.rb'
require_dependency 'ordering/commands/add_order.rb'
require_dependency 'ordering/commands/change_order_name.rb'
require_dependency 'ordering/events/order_added.rb'
require_dependency 'ordering/events/order_name_changed.rb'
require_dependency 'ordering/handlers/on_change_order_name.rb'
require_dependency 'ordering/handlers/on_order_added.rb'
