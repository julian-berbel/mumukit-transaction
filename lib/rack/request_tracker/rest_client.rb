module RestClient
  class << Request
    revamp :new do |_, _, args, hyper|
      hyper.(Rack::RequestTracker.with_transaction_headers args)
    end
  end
end if defined? RestClient::Request
