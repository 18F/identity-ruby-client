require 'login_dot_gov/saml/authn_request'
require 'login_dot_gov/saml/configuration'
require 'login_dot_gov/saml/response'

require 'cgi'

module LoginDotGov
  module SAML
    def self.encoded_authn_request
      auth_destination + '?SAMLRequest=' + CGI.escape(AuthnRequest.encoded_request)
    end

    def self.auth_destination
      LoginDotGov.configuration.idp_host + '/api/saml/' + LoginDotGov::SAML.configuration.auth_endpoint
    end
  end
end
