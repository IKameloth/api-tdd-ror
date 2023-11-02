module RequestSpecHelper
  # parse json response to hash
  def json
    JSON.parse(response.body)
  end
end
