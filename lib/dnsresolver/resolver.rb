module DNSResolver
  class Resolver
    include DNSResolver::Logger
    include DNSResolver::Config
    include DNSResolver::Exceptions

    attr_reader :resolver

    def initialize(options = {})
      @options = Config.settings.merge(options)
      @resolver = Resolv::DNS.new(:nameserver => @options[:nameservers])
    end

    def resolve_naptr(name)
      uris = []

      Fiber.new {
        begin
          @resolver.each_resource(name, Resolv::DNS::Resource::IN::NAPTR) do |res|
            regex = res.regex
            c = regex[0,1]
            substr = regex[1,regex.length - 2]
            match, replace = substr.split(c)
            uris << name.gsub(/#{match}/, replace)
          end
        rescue Exception => e
          raise DNSResolverError, "Error resolving #{name}"
        end
      }.resume

      uris
    end

  end
end