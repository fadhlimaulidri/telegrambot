module Service
  class Base
    include ::Contracts::Core

    C = Contracts

    def call
      run_callbacks :perform do
        perform
      end
    end

    def perform
      raise NotImplementedError
    end
  end

  class Error < StandardError; end
end
