def json_response
  JSON.parse(response.body)
end

def response_json; json_response; end
