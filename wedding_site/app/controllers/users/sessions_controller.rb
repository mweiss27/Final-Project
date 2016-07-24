class Users::SessionsController < Devise::SessionsController
	respond_to :json

	after_filter :log_failed_login, :only => :new

	  def create
	  	::Rails.logger.info "create"
	    super
	    ::Rails.logger.info "\n***\nSuccessful login with email_id : #{request.filtered_parameters["user"]}\n***\n"
	  end

	  private
	  def log_failed_login
	  	puts "failed"
	    ::Rails.logger.info "\n***\nFailed login with email_id : #{request.filtered_parameters["user"]}\n***\n" if failed_login?
	  end 

	  def failed_login?
	  	puts "failed???"
	    (options = env["warden.options"]) && options[:action] == "unauthenticated"
	  end 
end