module Service
  module JenkinsDC
    # for use, e.g. Service::Staging.deploy(bot, message)
    module_function
    def smoke_test_duty(*args); SmokeTestDuty.new(*args).perform; end
  end
end
