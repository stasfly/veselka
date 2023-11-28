Recaptcha.configure do |config|
  if Rails.env.production?
    config.site_key =    Rails.application.credentials.recaptcha.production.v2_site_key
    config.secret_key =  Rails.application.credentials.recaptcha.production.v2_secret_key
  else
    config.site_key =    Rails.application.credentials.recaptcha.development.v2_site_key
    config.secret_key =  Rails.application.credentials.recaptcha.development.v2_secret_key
  end
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'

  # Uncomment the following lines if you are using the Enterprise API:
  # config.enterprise = true
  # config.enterprise_api_key = 'AIzvFyE3TU-g4K_Kozr9F1smEzZSGBVOfLKyupA'
  # config.enterprise_project_id = 'my-project'
end
