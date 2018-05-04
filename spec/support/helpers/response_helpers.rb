module ResponseHelpers
  def json_body(force = false)
    @json_body = (!force && @json_body) || JSON.parse(response.body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include ResponseHelpers, type: :controller
end