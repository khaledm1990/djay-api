Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # change thie to an environment variable so we can configure it per environment
    origins "http://localhost:5173"

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      credentials: false
  end
end
