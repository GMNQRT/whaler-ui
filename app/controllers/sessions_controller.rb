class SessionsController < ApplicationController

  # GET /users/sign_in
  def new
    render layout: false
  end

  # POST /users/sign_in
  def create
    render layout: false
  end

  # DELETE /users/sign_out
  def destroy
    render layout: false
  end
end
