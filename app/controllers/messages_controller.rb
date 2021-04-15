class MessagesController < ApplicationController
  skip_before_action :authorize_request!, only: [:index, :show]

  def index
    messages = Message.all
    render json: messages
  end

  def show
    message = Message.find(params[:id])
    render json: message
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def create
    message = Message.create!(message_params)
    render json: message, status: :created
  end

  def destroy
    message = Message.find(params[:id])
    message.delete
    head :no_content
  end

  private

  def message_params
    params.require(:message).permit(:body, :published)
  end
end
