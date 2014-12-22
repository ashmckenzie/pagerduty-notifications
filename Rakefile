require 'bundler/setup'

require_relative './lib/pagerduty_notifications'

desc 'Start watching for Pager Duty incidents'
task :watch_incidents do
  settings = PagerDutyNotifications::Config.settings

  PagerDutyNotifications::Incidents.new.watch do |incidents|
    TerminalNotifier.notify(
      "#{incidents.count} in total",
      'title'   => settings.notification.title,
      'sound'   => settings.notification.sound,
      'appIcon' => settings.notification.icon_url,
      'open'    => settings.notification.link_url
    )
  end
end
