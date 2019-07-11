module Mumukit::Transaction::Middleware
  class Store
    def initialize(app)
      @app = app
    end

    def call(env)
      r = ActionDispatch::Request.new(env)
      Mumukit::Transaction.x_request_id = r.request_id
      Mumukit::Transaction.client_ip    = r.client_ip || r.remote_ip
      Mumukit::Transaction.current_uid  = env['HTTP_CURRENT_UID']

      @app.call(env)
    end
  end
end
