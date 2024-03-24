Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # TODO Em produção, substitua '*' por domínios específicos
    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head],
             expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'], # Cabeçalhos necessários para o Devise Token Auth
             credentials: false
  end
end
