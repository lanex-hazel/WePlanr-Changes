%i(get patch put post delete).each do |method|

  define_method "auth_#{method}" do |path, *args|
    params = args[0]
    user = args[1] || (path =~ /^\/api\/admin/ ? auth_admin : auth_user)
    headers = args[2] || {}

    auth_header = {
      HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Token.encode_credentials(user.auth_token)
    }

    send method, path,
      params: params,
      headers: headers.merge(auth_header)
  end

end
