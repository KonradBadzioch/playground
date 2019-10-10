module QualityControl
  module CommandHandlers
    class OnClientConfirmAudit
      include CommandHandler

      def call(cmd)
        with_aggregate(Audit, cmd.aggregate_id) do |audit|
          audit.client_confirm
        end
      end
    end
  end
end
