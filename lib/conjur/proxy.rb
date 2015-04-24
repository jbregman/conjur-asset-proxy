#
# Copyright (C) 2014 Conjur Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

require 'rack'
require 'rack/streaming_proxy'
require 'unicorn-rails'

module Conjur
  class Proxy
    def initialize url, conjur
      @conjur = conjur
      @proxy = Rack::StreamingProxy::Proxy.new nil do |request|
        ret = "#{url}#{request.path}"

        unless request.query_string.empty?
          ret = "#{ret}?#{request.query_string}"
        end

        ret
      end
    end

    attr_reader :proxy, :conjur

    def call env
      env['HTTP_AUTHORIZATION'] = conjur.credentials[:headers][:authorization]

      if (env['REQUEST_METHOD'] == 'POST' || env['REQUEST_METHOD'] == 'PUT')
        if !env.include?('CONTENT_LENGTH') && (!env.include?('TRANSFER_ENCODING') ||
            env['TRANSFER_ENCODING'] != 'chunked')
          env['CONTENT_LENGTH'] = '0'
        end
      end

      ret = proxy.call env

      # hack for Docker Hub & Registry API
      if ret[1].include?('x-docker-endpoints')
        ret[1]['x-docker-endpoints'] = env['HTTP_HOST']
      end

      ret
    end
    
    def configure options = {}
      if options[:insecure]
        Net::HTTP.class_eval do
          def use_ssl=(flag)
            flag = flag ? true : false
            if started? and @use_ssl != flag
              raise IOError, "use_ssl value changed, but session already started"
            end
            @use_ssl = flag

            self.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
        end
      end

      if options[:cacert]
        OpenSSL::SSL::SSLContext::DEFAULT_CERT_STORE.add_file options[:cacert]
      end

      Rack::StreamingProxy::Session.class_eval do
        # set timeout to 30 min, 30 seconds is not enought for uploading
        def start
          @piper = Servolux::Piper.new 'r', timeout: 1600
          @piper.child  { child }
          @piper.parent { parent }
        end
      end
    end

    def start options = {}
      configure options
      
      Rack::Server.start app: self, Port: options[:port] || 8080, Host: options[:address] || '127.0.0.1'
    end
  end
end
