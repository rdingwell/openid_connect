require 'spec_helper'

describe OpenIDConnect::Discovery::Provider::Config do
  let(:provider) { 'https://connect-op.heroku.com' }
  let(:endpoint) { "https://connect-op.heroku.com/.well-known/openid-configuration" }

  describe 'discover!' do
    it 'should setup given attributes' do
      mock_json :get, endpoint, 'discovery/config' do
        config = OpenIDConnect::Discovery::Provider::Config.discover! provider
        config.should be_instance_of OpenIDConnect::Discovery::Provider::Config::Response
        config.version.should == '3.0'
        config.issuer.should == 'https://connect-op.heroku.com'
        config.authorization_endpoint.should == 'https://connect-op.heroku.com/authorizations/new'
        config.token_endpoint.should == 'https://connect-op.heroku.com/access_tokens'
        config.user_info_endpoint.should == 'https://connect-op.heroku.com/user_info'
        config.check_id_endpoint.should == 'https://connect-op.heroku.com/id_token'
        config.refresh_session_endpoint.should be_nil
        config.end_session_endpoint.should be_nil
        config.jwk_url.should be_nil
        config.x509_url.should == 'https://connect-op.heroku.com/cert.pem'
        config.registration_endpoint.should == 'https://connect-op.heroku.com/connect/client'
        config.scopes_supported.should == ["openid", "profile", "email", "address"]
        config.response_types_supported.should == ["code", "token", "id_token", "code token", "code id_token", "id_token token"]
        config.acrs_supported.should be_nil
        config.user_id_types_supported.should == ["public", "pairwise"]
      end
    end
  end
end