module OpenIDConnect
  module Discovery
    module Provider
      class Config
        class Resource < SWD::Resource
          undef_required_attributes :principal, :service

          class Expired < SWD::Resource::Expired; end

          def initialize(host)
            @host = host
            @path ||= '/.well-known/openid-configuration'
            attr_missing!
          end

          def endpoint
            SWD.url_builder.build [nil, host, nil, path, nil, nil]
          rescue URI::Error => e
            raise SWD::Exception.new(e.message)
          end

          private

          def to_response_object(hash)
            Response.new hash
          end

          def cache_key
            md5 = Digest::MD5.hexdigest host
            "swd:resource:opneid-conf:#{md5}"
          end
        end
      end
    end
  end
end