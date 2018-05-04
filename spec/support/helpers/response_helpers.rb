module ResponseHelpers
  def json_body
    JSON.parse(response.body, symoblize_names: true)
  end
end

RSpec.configure do |config|
  config.include ResponseHelpers, type: :controller
end