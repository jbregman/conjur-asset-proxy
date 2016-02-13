name=proxy
old_version=0.5.3
version=0.5.3

build: clean
	gem build conjur-asset-$(name).gemspec

install: build
	gem install conjur-asset-$(name)-$(version).gem
	conjur plugin install -v $(version) $(name) 

clean:
	conjur plugin uninstall $(name)
	rm conjur-asset-$(name)-$(old_version).gem

show:
	conjur plugin show $(name)
