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

class Conjur::Command::Proxy < Conjur::Command
  desc "Proxy to a protected HTTP service"
  long_desc <<-DESC
Launch an HTTP proxy to a Conjur-protected service. The proxy adds a Conjur
authorization header to every request. This allows eg. using browser to access
a UI of a Conjur-protected web application. The proxy will keep running until
terminated.
  DESC

  arg :url
  command :proxy do |c|
    c.flag :p, :port,
        desc: "port to bind to",
        default_value: 8080,
        type: Integer

    c.flag :a, :address,
        desc: "address to bind to",
        default_value: "127.0.0.1"

    c.switch :k,
        desc: "Don't verificate HTTPS certificate"

    c.flag :cacert,
        desc: "Verify SSL using the provided cert file"

    c.action do |global_options, options, args|
      url = args.shift or help_now!("missing URL")

      if options[:k]
        options[:insecure] = true
      end

      unless url.start_with?('http://') || url.start_with?('https://')
        url = url.gsub(/^(.+?\:(\/)?(\/)?)?/, 'https://')
      end

      require 'uri'

      uri = URI.parse(url)
      uri.path = ''
      uri.query = nil

      url = uri.to_s

      options.slice! :port, :address, :insecure, :cacert
      options.delete :port unless options[:port].respond_to? :to_i

      require 'conjur/proxy'

      Conjur::Proxy.new(url, api).start options
    end
  end
end
