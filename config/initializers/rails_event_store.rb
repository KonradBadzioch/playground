require 'rails_event_store'
require 'aggregate_root'
require 'arkency/command_bus'

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  # Subscribe event handlers below
  Rails.configuration.event_store.tap do |store|
    store.subscribe_to_all_events(EventsLogger.new(Rails.logger))
    # store.subscribe(Orders::OnOrderAdded, to: [Ordering::Events::OrderAdded])
    # store.subscribe(->(event) { SendOrderConfirmation.new.call(event) }, to: [OrderSubmitted])
    # store.subscribe_to_all_events(->(event) { Rails.logger.info(event.type) })
    store.subscribe(QualityControl::ProcessManager, to: [QualityControl::Events::AuditEvaluated, QualityControl::Events::ClientConfirmedAudit, QualityControl::Events::CommissionConfirmedAudit])
  end

  # Register command handlers below
  Rails.configuration.command_bus.tap do |bus|
    # bus.register(Ordering::Commands::AddOrder, Ordering::Handlers::OnOrderAdded.new)

    bus.register(QualityControl::Commands::AddAudit, QualityControl::CommandHandlers::OnAddAudit.new)
    bus.register(QualityControl::Commands::ClientConfirmAudit, QualityControl::CommandHandlers::OnClientConfirmAudit.new)
    bus.register(QualityControl::Commands::CommissionConfirmAudit, QualityControl::CommandHandlers::OnCommissionConfirmAudit.new)
    bus.register(QualityControl::Commands::EvaluateAudit, QualityControl::CommandHandlers::OnEvaluateAudit.new)

    # bus.register(PrintInvoice, Invoicing::OnPrint.new)
    # bus.register(SubmitOrder,  ->(cmd) { Ordering::OnSubmitOrder.new.call(cmd) })
  end
end
