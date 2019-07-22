module Rack::RequestTracker::Middleware
  class Store
    def initialize(app)
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)
      Rack::RequestTracker.request_id    = request.request_id
      Rack::RequestTracker.forwarded_for = first_forward(request.x_forwarded_for) || request.remote_ip
      Rack::RequestTracker.request_uid   = request.headers['X-REQUEST-UID']

      @app.call(env)
    end

    private

    def first_forward(forwards)
      return unless forwards
      forwards.split(', ').first
    end
  end
end
