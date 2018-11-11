# config/initializers/hyperloop.rb
# If you are not using ActionCable, see http://ruby-hyperloop.io/docs/models/configuring-transport/
Hyperloop.configuration do |config|
  config.transport = :action_cable # or :pusher or :simpler_poller or :none
  config.prerendering = :off # or :on
  config.import 'reactrb/auto-import' # will automatically bridge js components to hyperloop components
  config.import 'jquery', client_only: true  # remove this line if you don't need jquery
  config.import 'hyper-component/jquery', client_only: true # remove this line if you don't need jquery
  config.import 'opal_hot_reloader' if Rails.env.development?
end

module Hyperloop # or Hyperstack as appropriate
  def self.on_error(*args)
    ::Rails.logger.debug "\033[0;31;1mHYPERLOOP APPLICATION ERROR: #{args.join(", ")}\n"\
                         "To further investigate you may want to add a debugging "\
                         "breakpoint in config/initializers/hyperstack.rb\033[0;30;21m"
  end
end if Rails.env.development?
