name=proxy
old_version=0.5.3
version=0.8

default: test

test: 
	conjur policy load --collection $(name)/$(version) --as-group security_admin test-policy.rb
	conjur hostfactory create --as-group security_admin -l $(name)/$(version)/test/puppet puppethosts

	#conjur script execute --collection $(name)/$(version) test-data.rb
#	conjur variable values add $(name)/$(version)/test/password test
#	conjur variable values add $(name)/$(version)/test/username test
#	conjur proxy -t basic \
#		-u $(name)/$(version)/test/username \
#		-w $(name)/$(version)/test/password \
#		http://browserspy.dk &
#	sleep 10
#	curl http://localhost:8080/password-ok.php | grep Success
