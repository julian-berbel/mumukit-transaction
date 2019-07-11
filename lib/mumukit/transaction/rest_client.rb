module RestClient
  class << Request
    revamp :new do |_, _, args, hyper|
      hyper.(args.deep_merge headers: Mumukit::Transaction.transaction_headers)
    end
  end
end if defined? RestClient::Request
