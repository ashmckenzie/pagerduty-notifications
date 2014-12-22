module PagerDutyNotifications
  class Incidents

    def initialize status='triggered'
      @status         = status
      @seen_incidents = []
    end

    def watch
      while true do
        response  = pagerduty.get('incidents', fields: 'id,html_url,trigger_summary_data', status: status)
        incidents = response.incidents.reject { |x| seen_incidents.include?(x.id) }

        unless incidents.empty?
          print 'x'
          incidents.each { |x| seen_incidents << x.id }
          yield(incidents)
        else
          print '.'
        end

        sleep(settings.sleep_for)
      end
    end

    private

      attr_accessor :seen_incidents
      attr_reader   :status

      def settings
        @settings ||= PagerDutyNotifications::Config.settings
      end

      def pagerduty
        @pagerduty ||= PagerDuty::Connection.new(settings.account.name, settings.account.token)
      end

  end
end
