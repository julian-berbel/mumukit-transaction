require 'request_store'
require 'mumukit/core'

module Mumukit::Transaction
  LOG_TAGS = %i(request_id forwarded_for request_uid)

  class << self
    def transaction_headers
      LOG_TAGS.map { |it| [to_header(it), send(it)] }.to_h
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

    private

    def to_header(log_tag)
      "X-#{log_tag.upcase}".gsub('_', '-')
    end
  end
end

require_relative 'transaction/logger_formatter'
require_relative 'transaction/rack_common_logger'
require_relative 'transaction/rest_client'
require_relative 'transaction/middleware'
require_relative 'transaction/version'
