name=proxy
old_version=0.5.3
version=0.6.0

build: clean
	gem build conjur-asset-$(name).gemspec

install: build
	gem install conjur-asset-$(name)-$(version).gem
	conjur plugin install -v $(version) $(name) 

clean:
	#conjur plugin uninstall fails when there is
	#a bug in the plugin, so we need to manuall remove the plugin
	cat ~/.conjurrc | grep -v $(name) > /tmp/.conjurrc-$(name)
	mv /tmp/.conjurrc-$(name) ~/.conjurrc
	touch conjur-asset-$(name)-$(old_version).gem
	rm conjur-asset-$(name)-$(old_version).gem

test-conjur:
	conjur proxy http://httpbin.org

