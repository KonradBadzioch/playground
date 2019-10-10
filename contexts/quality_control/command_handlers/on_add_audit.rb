module QualityControl
  module CommandHandlers
    class OnAddAudit
      include CommandHandler

      def call(cmd)
        aggregate_id = SecureRandom.uuid
        with_aggregate(Audit, aggregate_id) do |audit|
          audit.add
        end
      end
    end
  end
end
