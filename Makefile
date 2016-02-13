name=proxy
version=0.5.2

build: clean
	gem build conjur-asset-$(name).gemspec

install: build
	gem install conjur-asset-$(name)-$(version).gem
	conjur plugin install -v $(version) $(name) 

clean:
	conjur plugin uninstall $(name)
	rm conjur-asset-$(name)-$(version).gem

show:
	conjur plugin show $(name)
