require 'em-proxy'

module Hydra5

  class Logger
    [:info, :error].each do |m|
      define_method m do |msg|
        msg = msg.join(", ") if msg.is_a? Array
        puts ["Hydra5", m, msg].join(" :: ")
      end
    end
  end

  class Proxy
    def initialize(options)
      @listen = options.delete(:listen) || 8080
      @user = options.delete(:user) || 'root'
      @key = options.delete(:key)
      @log = Logger.new

      @hosts = options.delete(:hosts)
      @hosts = @hosts.inject({}) {|h,k| h[@hosts.index(k)] = k; h}

      @log.info "Establishing #{@hosts.size} SOCKS5 tunnels"
      @@live = {}
      @pids = []
    end

    def start!
      EM.epoll
      EM.run do
        @hosts.each do |index, host|
          tunnel = <<-CMD
          ssh #{@user}@#{host} -D #{7000 + index} -NT
          -o StrictHostKeyChecking=no
          -o ServerAliveInterval=300
          -o ConnectTimeout=5
          -o ExitOnForwardFailure=yes
          -i #{@key}
          CMD

          @pids << EM.system(tunnel) do |cmd, out|
            @log.error ["Connection closed", out, @hosts[index]]
            @@live.delete(index)

            if @@live.empty?
              @log.info "No live tunnels left, exiting"
              exit
            end
          end

          @@live[index] = host
        end

        at_exit do
          pids = @pids.join(' ')
          unless system("kill #{pids}")
            @log.error "Could not kill all tunnels: #{pids}"
          end
        end

        @log.info "Starting proxy on port #{@listen}"

        ::Proxy.start(:host => "0.0.0.0", :port => @listen, :debug => @verbose) do |conn|
          tunnel = @@live.keys.shuffle.first

          puts "routing connection to #{@@live[tunnel]}"
          conn.server :srv, :host => "127.0.0.1", :port => 7000 + tunnel, :relay_client => true, :relay_server => true
        end
      end
    end
  end
end
