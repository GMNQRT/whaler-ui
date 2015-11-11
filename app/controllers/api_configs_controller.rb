class ApiConfigsController < ApplicationController
  def new
    respond_to :html
  end

  def show
    config_file = File.join(Rails.root, 'public', 'api_config.json')
    if File.exist? config_file
      render :json, file: config_file
    else
      render :json, status: 404, text: nil
    end
  end

  def create
    config_file = File.join(Rails.root, 'public', 'api_config.json')

    File.write(config_file, params.slice(:scheme, :host, :port).to_json)

    render json: params.slice(:scheme, :host, :port)
  end
end
