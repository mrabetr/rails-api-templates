class PublicController < ApplicationController
  skip_before_action :authorize_request!, only: [:public]

  def public
    render json: { message: 'You don\'t need to be authenticated to call this' }
  end
end
