module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def download_link
    { download: request.original_url.gsub(controller_name, controller_name + '.csv') }
  end

  def download_link_of name
    request.original_url.gsub('hub_', '').gsub(name, name + '.csv')
  end
end