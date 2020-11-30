require 'delegate'

module LoginDotGov
  module SAML
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new(LoginDotGov.configuration)
      yield(configuration)
    end

    class Configuration < SimpleDelegator
      attr_accessor :acs_url
      attr_accessor :auth_endpoint
      attr_accessor :assertion_encryption
    end
  end
end
