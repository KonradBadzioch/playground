require 'aggregate_root'

module Ordering
  class Order
    include AggregateRoot

    def create(name)
      apply Ordering::Events::OrderAdded.new(data: { order_id: @id, name: name }, metadata: { timestamp: timestamp })
    end

    def change_name(name)
      apply Ordering::Events::OrderNameChanged.new(data: { order_id: @id, name: name, metadata: { timestamp: timestamp } })
    end

    private

    def initialize(id)
      @id = id
      @name = ''
      @state = 0
    end

    on Ordering::Events::OrderNameChanged do |event|
      @state = :name_changed
    end

    on Ordering::Events::OrderAdded do |event|
      @name = event.name
      @state = :default
    end

    def timestamp
      DateTime.now
    end
  end
end

# command_bus = Rails.configuration.command_bus
# cmd = Ordering::Commands::AddOrder.new(order_id: 0, name: 'My first Event')
# command_bus.call(cmd)