module Secured
  extend ActiveSupport::Concern

  SCOPES = {
    '/api/private'    => nil,
    '/api/private-scoped' => ['read:messages']
  }

  included do
    before_action :authorize_request!
  end

  private

  def authorize_request!
    # @auth_payload is used to check the included scope
    # request.headers comes from the http requests to the specific API endpoint
    @auth_payload, @auth_header = AuthorizationService.new(request.headers).authenticate_request!

    render json: { errors: ['Insufficient scope'] }, status: :forbidden unless scope_included
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  def scope_included
    # The intersection of the scopes included in the given JWT and the ones in the SCOPES hash needed to access
    # the PATH_INFO, should contain at least one element
    if SCOPES[request.env['PATH_INFO']] == nil
      true
    else
      (String(@auth_payload['scope']).split(' ') & (SCOPES[request.env['PATH_INFO']])).any?
    end
  end
end
