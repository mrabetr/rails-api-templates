class MessagesController < ApplicationController
  skip_before_action :authorize_request!, only: [:index, :show]
  before_action :set_message, only: [:show, :update, :destroy]

  def index
    @messages = Message.all
    render json: @messages
  end

  def show
    render json: @message
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      render json: @message, status: :created
    else
      render_error
    end
  end

  def update
    if @message.update(message_params)
      render json: @message
    else
      render_error
    end
  end

  def destroy
    @message.delete
    head :no_content
  end

  private

  def message_params
    params.require(:message).permit(:body, :published)
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def render_error
    render json: { errors: message.errors.full_messages },
      status: :unprocessable_entity
  end
end
