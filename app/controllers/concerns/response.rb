module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def download_link
    { download: request.original_url.gsub(controller_name, controller_name + '.csv') }
  end
end