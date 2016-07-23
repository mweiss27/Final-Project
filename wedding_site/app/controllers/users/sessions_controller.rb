# class Users::SessionsController < Devise::SessionsController
# 	#respond_to :json
# 	def resource_name
# 		:user
# 	end

# 	def resource
# 		@resource ||= User.new
# 	end

# 	def devise_mapping
# 		@devise_mapping ||= Devise.mappings[:user]
# 	end

# 	def sign_in_and_redirect(resource_or_scope, resource=nil)
# 		puts "sign in and redirect"
# 	    scope = Devise::Mapping.find_scope!(resource_or_scope)
# 	    resource ||= resource_or_scope
# 	    sign_in(scope, resource) unless warden.user(scope) == resource
# 	    return render :json => {:success => true}
#   	end

#   	def failure
#   		puts "SessionController failed!"
# 		return render :json => {:success => false, :errors => ["Login failed."]}
# 	end

# end