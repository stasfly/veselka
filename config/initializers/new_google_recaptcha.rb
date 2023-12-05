if Object.const_defined?('NewGoogleRecaptcha')
  NewGoogleRecaptcha.setup do |config|
    environment = Rails.env.production? ? 'production' : 'development'
    config.site_key   = Rails.application.credentials.recaptcha[environment].v3_site_key
    config.secret_key = Rails.application.credentials.recaptcha[environment].v3_secret_key
    config.minimum_score = 0.75
  end
end
