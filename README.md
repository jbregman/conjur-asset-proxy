# Conjur::Asset::Proxy

Simple HTTP proxy which adds Conjur authentication headers.

## Installation

    $ conjur plugin install proxy

## Usage

    $ conjur proxy http://protected-service.example.com

    Conjur proxy to http://protected-service.example.com started on http://localhost:32123
    Press Ctrl-C to stop.
## Working with Plugins
To change the version of the plugin - you modify the lib/conjur/asset/proxy/version.rb file
'''
module Conjur
  module Asset
    module Proxy
      VERSION = "0.5.3"
    end
  end
end
'''
To change the description when you run conjur plugin show, modify the conjur-asset-proxy.gemspec
'''
  spec.name          = "conjur-asset-proxy"
  spec.version       = Conjur::Asset::Proxy::VERSION
  spec.authors       = ["Rafa Rzepecki", "Mikalai Sevastsyana","Josh Bregman"]
  spec.email         = ["rafal@conjur.net", "mikalai@conjur.net","josh.bregman@conjur.net"]
  spec.summary       = %q{Simple HTTP proxy which adds authentication headers from Conjur"}
  spec.homepage      = "https://github.com/conjurinc/conjur-asset-proxy"
  spec.license       = "MIT"
'''
## Contributing

1. Fork it ( https://github.com/[my-github-username]/conjur-asset-proxy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
