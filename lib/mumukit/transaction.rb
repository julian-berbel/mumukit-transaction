require 'request_store'
require 'mumukit/core'

module Mumukit::Transaction
  LOG_TAGS = %i(x_request_id client_ip current_uid)

  def self.transaction_headers
    LOG_TAGS.map { |it| [it.upcase, send(it)] }.to_h
  end

  LOG_TAGS.each do |it|
    define_singleton_method(it) { RequestStore.store[it] }
    define_singleton_method("#{it}=") { |value| RequestStore.store[it] = value }
  end

  def self.compute_tags
    LOG_TAGS
        .map { |it| send it }
        .compact
        .join(', ')
  end
end

require_relative 'transaction/logger_formatter'
require_relative 'transaction/rack_common_logger'
require_relative 'transaction/rest_client'
require_relative 'transaction/version'
