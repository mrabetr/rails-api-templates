class ApplicationController < ActionController::API
  # OAuth: white-list approach. This includes :authorize_request!
  include Secured
end
