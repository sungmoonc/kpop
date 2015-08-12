
class SessionsController < Devise::SessionsController  	
    def create
	  resource = warden.authenticate!(:scope => resource_name, :recall => "main#index")
	  sign_in_without_redirect(resource_name, resource)
	  @after_sign_in_path = after_sign_in_path_for(resource)
	end

	def sign_in_without_redirect(resource_or_scope, resource=nil)
	  scope = Devise::Mapping.find_scope!(resource_or_scope)
	  resource ||= resource_or_scope
	  sign_in(scope, resource) unless warden.user(scope) == resource
	end
end  