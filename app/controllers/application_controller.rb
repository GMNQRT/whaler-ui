class ApplicationController < ActionController::Base
  layout false, except: :layout

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def layout
    render text: nil, layout: true
  end
end
