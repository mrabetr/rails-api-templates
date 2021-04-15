class PublicController < ApplicationController
  skip_before_action :authenticate_request!, only: [:public]

  def public
    render json: { message: 'You don\'t need to be authenticated to call this' }
  end
end
