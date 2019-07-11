module Mumukit::Transaction::Middleware
  class Store
    def initialize(app)
      @app = app
    end

    def call(env)
      r = ActionDispatch::Request.new(env)
      Mumukit::Transaction.request_id    = r.request_id
      Mumukit::Transaction.forwarded_for = r.x_forwarded_for || r.remote_ip
      Mumukit::Transaction.request_uid   = env['HTTP_X_REQUEST_UID']

      @app.call(env)
    end
  end
end
