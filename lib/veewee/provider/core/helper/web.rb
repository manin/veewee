module Veewee
  module Provider
    module Core
      module Helper
        require 'webrick'

        include WEBrick

        module Servlet

          class FileServlet < WEBrick::HTTPServlet::AbstractServlet
            attr_reader :ui, :threaded

            def initialize(server,localfile,ui,threaded)
              super(server)
              @server=server
              @localfile=localfile
              @ui=ui
              @threaded=threaded
            end

            def do_GET(request,response)
              response['Content-Type']='text/plain'
              response.status = 200
              content = File.open(@localfile, "r").read
              response.body =
              case File.extname(@localfile)
              when ".erb"
                ui.info "Rendering and serving file #{@localfile}"
                ERB.new(content).result(binding)
              else
                ui.info "Serving file #{@localfile}"
                content
              end
              if not @threaded
                ui.info "Shutting down for #{@localfile}"
                @server.shutdown
              end
            end
          end
        end

        module Web
          def wait_for_http_request(filename, urlname, options) # original blocking
            server_for_http_request(filename, urlname, options) do |server|
              server.start
            end
          end

          def allow_for_http_request(filename, urlname, options) # start in new thread
            server_for_http_request(filename, urlname, options.merge({:threaded => false})) do |server|
              t = Thread.new { server.start }
              t.abort_on_exception = true
            end
          end

          def server_for_http_request(filename, urlname, options, &block)
            # Calculate the OS equivalent of /dev/null , on windows this is NUL:
            # http://www.ruby-forum.com/topic/115472
            fn = test(?e, '/dev/null') ? '/dev/null' : 'NUL:'
            webrick_logger = WEBrick::Log.new(fn, WEBrick::Log::INFO)

            timeout = options[:timeout] || 60
            Timeout.timeout(timeout) do
              server =
              ::WEBrick::HTTPServer.new(
                :Port => options[:port],
                :Logger => webrick_logger,
                :AccessLog => webrick_logger
              )
              env.logger.debug("mounting file #{urlname}")
              server.mount("#{urlname}", Veewee::Provider::Core::Helper::Servlet::FileServlet, filename, ui, options[:threaded])
              trap("INT"){
                server.shutdown
                ui.info "Stopping webserver"
                exit
              }
              yield server
            end
          rescue Timeout::Error
            server.shutdown unless server.nil?
            raise "File #{filename.inspect} was not requested in #{timeout}seconds, are you using firewall blocking connections to port: #{options[:port]}?"
          end

        end #Class
      end #Module
    end #Module
  end #Module
end #Module
