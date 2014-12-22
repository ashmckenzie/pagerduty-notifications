require 'singleton'
require 'hashie'

module PagerDutyNotifications
  class Config

    include Singleton

    def self.settings()  instance.settings; end

    def initialize
      Dotenv.load('.env_development', '.env')
    end

    def settings
      @settings ||= begin
        Hashie::Mash.new(
          {
            account: {
              name:   ENV['PAGERDUTY_ACCOUNT_NAME']   || raise("Missing ENV['PAGERDUTY_ACCOUNT_NAME'], add to .env.development or .env"),
              token:  ENV['PAGERDUTY_ACCOUNT_TOKEN']  || raise("Missing ENV['PAGERDUTY_ACCOUNT_TOKEN'], add to .env.development or .env")
            },

            notification: {
              title:      'PagerDuty Alert(s)',
              sound:      ENV['PAGERDUTY_NOTIFICATION_SOUND']    || 'Blow',
              link_url:   ENV['PAGERDUTY_NOTIFICATION_LINK_URL'] || 'https://zendesk.pagerduty.com/dashboard',
              icon_url:   'http://lkhill.com/wp/wp-content/uploads/2014/11/pager-duty-icon.png'
            },

            sleep_for: ENV['PAGERDUTY_NOTIFICATION_SLEEP_FOR'] || 15
          }
        )
      end
    end

  end
end
