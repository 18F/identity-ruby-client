require 'base64'
require 'nokogiri'
require 'securerandom'
require 'zlib'

module LoginDotGov
  module SAML
    class AuthnRequest
      def self.encoded_request
        new.encoded_request
      end

      def initialize
        @builder = Nokogiri::XML::Builder.new do |xml|
          xml['samlp'].AuthnRequest(
            'AssertionConsumerServiceURL' => config.acs_url,
            'Destination' => LoginDotGov::SAML.auth_destination,
            'Version' => '2.0',
            'ID' => "_#{SecureRandom.uuid}",
            'IssueInstant' => Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ'),
            'xmlns:saml' => 'urn:oasis:names:tc:SAML:2.0:assertion',
            'xmlns:samlp' => 'urn:oasis:names:tc:SAML:2.0:protocol'
          ) do
            xml['saml'].Issuer config.issuer
            xml['samlp'].NameIDPolicy(
              'AllowCreate' => 'true',
              'Format' => 'urn:oasis:names:tc:SAML:1.1:nameid-format:persistent'
            )
          end
        end
        @request = builder.to_xml(save_with: save_options).strip
      end

      def encoded_request
        puts "Request: #{request}"
        encode(deflate(request))
      end

      private

      attr_reader :builder, :request

      def config
        LoginDotGov::SAML.configuration
      end

      def save_options
        Nokogiri::XML::Node::SaveOptions::AS_XML +
        Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
      end

      # https://github.com/onelogin/ruby-saml/blob/9f710c5028b069bfab4b9e2b66891e0549765af5/lib/onelogin/ruby-saml/saml_message.rb#L151
      def deflate(string)
        Zlib::Deflate.deflate(string, 9)[2..-5]
      end

      def encode(string)
        Base64.encode64(string).gsub(/\n/, '')
      end
    end
  end
end
