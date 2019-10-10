module QualityControl
  module CommandHandlers
    class OnCommissionConfirmAudit
      include CommandHandler

      def call(cmd)
        with_aggregate(Audit, cmd.aggregate_id) do |audit|
          audit.commission_confirm
        end
      end
    end
  end
end
