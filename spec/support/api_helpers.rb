module ApiHelpers
  def auth_user(user)
    post '/auth/sign_in',
         params: { email: user.email, password: user.password }.to_json,
         headers: {
           'Content-Type' => 'application/json',
           'Accept' => 'application/json'
         }

    token = response.headers['access-token']
    client = response.headers['client']
    uid = response.headers['uid']

    {
      'access-token' => token,
      'client' => client,
      'uid' => uid
    }
  end

  def json_response
    JSON.parse(response.body)
  end
end
