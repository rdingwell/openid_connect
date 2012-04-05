module OpenIDConnect
  class AccessToken < Rack::OAuth2::AccessToken::Bearer
    attr_required :client
    attr_optional :id_token

    def initialize(attributes = {})
      super
      @token_type = :bearer
    end

    def user_info!(scheme = :openid)
      hash = resource_request do
        get client.user_info_uri
      end
      ResponseObject::UserInfo::OpenID.new hash
    end

    def id_token!
      client.check_id_uri
      hash = resource_request do
        get client.check_id_uri
      end
      ResponseObject::IdToken.new hash
    end

    def authenticate(request)
      request.header["Authorization"] = "Bearer #{access_token}"
      request.http_header.request_query ||= {}
      request.http_header.request_query[:access_token] = access_token
    end
   
            
    private

    def resource_request
      res = yield
      case res.status
      when 200
        JSON.parse(res.body).with_indifferent_access
      when 400
        raise BadRequest.new('API Access Faild', res)
      when 401
        raise Unauthorized.new('Access Token Invalid or Expired', res)
      when 403
        raise Forbidden.new('Insufficient Scope', res)
      else
        raise HttpError.new(res.status, 'Unknown HttpError', res)
      end
    end
  end
end