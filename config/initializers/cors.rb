Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://fmap-alb-2099770241.ap-northeast-1.elb.amazonaws.com'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
