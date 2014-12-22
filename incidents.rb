#!/usr/bin/env ruby

require "bundler/setup"

# require 'pry'
require "dotenv"
require "pager_duty/connection"
require 'terminal-notifier'

Dotenv.load ".env_development", '.env'

PAGERDUTY_ACCOUNT = ENV['PAGERDUTY_ACCOUNT'] || raise("Missing ENV['PAGERDUTY_ACCOUNT'], add to .env.development or .env")
PAGERDUTY_TOKEN = ENV['PAGERDUTY_TOKEN'] || raise("Missing ENV['PAGERDUTY_TOKEN'], add to .env.development or .env")

PAGERDUTY_NOTIFICATION_TITLE = 'PagerDuty Alert(s)'
PAGERDUTY_NOTIFICATION_DASHBOARD_URL = 'https://zendesk.pagerduty.com/dashboard'
PAGERDUTY_NOTIFICATION_ICON_URL = 'http://lkhill.com/wp/wp-content/uploads/2014/11/pager-duty-icon.png'

PAGERDUTY_NOTIFICATION_SOUND = ENV['PAGERDUTY_NOTIFICATION_SOUND'] || 'Blow'
PAGERDUTY_NOTIFICATION_SLEEP_FOR = ENV['PAGERDUTY_NOTIFICATION_SLEEP_FOR'] || 15

pagerduty = PagerDuty::Connection.new(PAGERDUTY_ACCOUNT, PAGERDUTY_TOKEN)

seen_incidents = []

while true do
  response = pagerduty.get('incidents', fields: 'id,html_url,trigger_summary_data', status: 'triggered')
  incidents = response.incidents.reject { |x| seen_incidents.include?(x.id) }

  unless incidents.empty?
    print 'x'
    incidents.each { |x| seen_incidents << x.id }

    TerminalNotifier.notify("#{incidents.count} in total", title: PAGERDUTY_NOTIFICATION_TITLE, 'appIcon' => PAGERDUTY_NOTIFICATION_ICON_URL, sound: PAGERDUTY_NOTIFICATION_SOUND, open: PAGERDUTY_NOTIFICATION_DASHBOARD_URL)

  else
    print '.'
  end

  sleep PAGERDUTY_NOTIFICATION_SLEEP_FOR
end
