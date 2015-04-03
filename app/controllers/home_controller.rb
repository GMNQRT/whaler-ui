class HomeController < ApplicationController
  def index
  end

  def toto
    render layout: false
  end
end