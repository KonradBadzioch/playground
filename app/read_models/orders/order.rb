module Orders
  class Order < ApplicationRecord
    self.table_name = 'orders'
    enum state: %i[default name_changed confirmed]
  end
end
