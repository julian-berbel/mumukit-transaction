require 'request_store'
require 'mumukit/core'

module Rack::RequestTracker
  LOG_TAGS = %i(request_id forwarded_for request_uid organization)

  class << self
    def transaction_headers
      LOG_TAGS.map { |it| [to_header(it), send(it)] }.to_h.compact
    end

    LOG_TAGS.each do |it|
      define_method(it) { RequestStore.store[it] }
      define_method("#{it}=") { |value| RequestStore.store[it] = value }
    end

    def compute_tags
      LOG_TAGS
          .map { |it| send it }
          .compact
          .join(', ')
    end

    def with_transaction_headers(args)
      is_safe_domain?(URI.parse(args[:url]).hostname) ? args.deep_merge(headers: transaction_headers) : args
    end

    private

    def to_header(log_tag)
      "X-#{log_tag.upcase}".gsub('_', '-')
    end

    def is_safe_domain?(hostname)
      safe_domains.any? { |it| hostname.end_with? it }
    end

    def safe_domains
      []
    end
  end
end

require_relative 'request_tracker/logger_formatter'
require_relative 'request_tracker/rack_common_logger'
require_relative 'request_tracker/rest_client'
require_relative 'request_tracker/middleware'
require_relative 'request_tracker/version'
