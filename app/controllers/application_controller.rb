class ApplicationController < ActionController::API
  # OAuth: white-list approach.
  include Secured
end
