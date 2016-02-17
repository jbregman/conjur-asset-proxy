name=proxy
old_version=0.5.3
version=0.5.3

default: test

test: 
	conjur plugin show $(name)
	conjur policy load --collection $(name)/$(version) test-policy.rb
	#conjur script execute --collection $(name)/$(version) test-data.rb
	conjur variable values add $(name)/$(version)/test/password test
	conjur variable values add $(name)/$(version)/test/username test
	conjur proxy -t basic \
		-u $(name)/$(version)/test/username \
		-w $(name)/$(version)/test/password \
		http://browserspy.dk &
	sleep 10
	curl http://localhost:8080/password-ok.php | grep Success
