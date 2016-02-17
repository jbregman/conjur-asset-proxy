policy "test" do

	username = variable "username"
	password = variable "password"

	layer "puppet" do

		can 'read', username
		can 'execute', username
	
		can 'read', password
		can 'execute', password	

	end 
end
