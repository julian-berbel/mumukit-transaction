module Mumukit::Transaction::Middleware
  class Store
    def initialize(app)
      @app = app
    end

    def call(env)
      r = ActionDispatch::Request.new(env)
      Mumukit::Transaction.x_request_id    = r.request_id
      Mumukit::Transaction.x_forwarded_for = r.x_forwarded_for || r.remote_ip
      Mumukit::Transaction.current_uid     = env['HTTP_CURRENT_UID']

      @app.call(env)
    end
  end
end
