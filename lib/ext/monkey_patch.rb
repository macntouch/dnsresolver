class EventMachine::DnsResolver::Request
  def self.new(*args)
    request = super
    request.retry_interval = 1
    request.max_tries = 2
    request
  end
end

class EventMachine::DnsResolver::DnsSocket
  def post_init
    @requests = {}
    @connected = true
    EM.add_periodic_timer(0.02, &method(:tick))
  end
end