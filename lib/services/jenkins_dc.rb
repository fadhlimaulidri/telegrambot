module Service
  module JenkinsDC
    # for use, e.g. Service::Staging.deploy(bot, message)
    module_function
    def runsmoketest(*args); RunSmoketest.new(*args).perform; end
    def smoke_test_duty(*args); SmokeTestDuty.new(*args).perform; end
    def failed_smoke_test(*args); FailedSmokeTest.new(*args).perform; end
  end
end
