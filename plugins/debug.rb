class Debug < Mumblebot::Plugin
  def setup

  end

  def respond_to?(args)
    true
  end

  def method_missing(method, *args)
    puts "method: #{method} (#{args.count} args)"
  end
end
