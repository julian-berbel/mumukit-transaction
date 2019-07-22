class Logger::Formatter
  remove_const :Format
  Format = "%s, [%s#%d] %5s -- %s: [%s] %s\n".freeze

  def call(severity, time, progname, msg)
    Format % [severity[0..0], format_datetime(time), $$, severity, progname, Rack::RequestTracker.compute_tags, msg2str(msg)]
  end
end
