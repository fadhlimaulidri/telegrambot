module Service
  module Staging
    # for use, e.g. Service::Staging.deploy(bot, message)
    module_function
    def deploy(*args); Deploy.new(*args).perform; end
  end
end
