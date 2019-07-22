class Rack::CommonLogger
  remove_const :FORMAT
  FORMAT = %{%s - %s [%s] [%s] "%s %s%s %s" %d %s %0.4f\n}

  private

  def log(env, status, header, began_at)
    now = Time.now
    length = extract_content_length(header)

    msg = FORMAT % [
        env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"] || "-",
        env["REMOTE_USER"] || "-",
        now.strftime("%d/%b/%Y:%H:%M:%S %z"),
        Rack::RequestTracker.compute_tags,
        env[Rack::REQUEST_METHOD],
        env[Rack::PATH_INFO],
        env[Rack::QUERY_STRING].empty? ? "" : "?"+env[Rack::QUERY_STRING],
        env["HTTP_VERSION"],
        status.to_s[0..3],
        length,
        now - began_at ]

    logger = @logger || env['rack.errors']
    # Standard library logger doesn't support write but it supports << which actually
    # calls to write on the log device without formatting
    if logger.respond_to?(:write)
      logger.write(msg)
    else
      logger << msg
    end
  end
end
