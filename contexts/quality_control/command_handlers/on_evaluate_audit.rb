module QualityControl
  module CommandHandlers
    class OnEvaluateAudit
      include CommandHandler

      def call(cmd)
        with_aggregate(Audit, cmd.aggregate_id) do |audit|
          audit.evaluate(cmd.evaluation)
        end
      end
    end
  end
end
