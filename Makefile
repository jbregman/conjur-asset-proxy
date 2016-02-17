name=proxy
old_version=0.5.3
version=0.5.3

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

test-basic: 
	conjur plugin show $(name)
	conjur policy load --collection $(name)/$(version) test_basic/test-policy.rb
	#conjur script execute --collection $(name)/$(version) test_basic/test-data.rb
	conjur variable values add $(name)/$(version)/test/password test
	conjur variable values add $(name)/$(version)/test/username test
	conjur proxy --at basic \
		--bu $(name)/$(version)/test/username \
		--bp $(name)/$(version)/test/password \
		http://browserspy.dk &
	sleep 10
	curl http://localhost:8080/password-ok.php | grep Success
