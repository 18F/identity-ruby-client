module LoginDotGov
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :idp_host
    attr_accessor :issuer
    attr_accessor :ial
    attr_accessor :attribute_bundle
    attr_accessor :private_key
  end
end
