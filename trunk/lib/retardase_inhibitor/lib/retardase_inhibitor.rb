module UrlWriterRetardaseInhibitor
  module ActionController
    def self.included(ac)
      ac.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def action_mailer_default_url
        begin
          request = self.request
          ::ActionController::UrlWriter.module_eval do
            @old_default_url_options = default_url_options.clone
            
            default_url_options[:host] = (Toolbawks.default_host.nil?) ? request.env["SERVER_NAME"] : Toolbawks.default_host
            default_url_options[:port] = (Toolbawks.default_port.nil?) ? request.env["SERVER_PORT"] : Toolbawks.default_port
            
            protocol = (Toolbawks.default_protocol.nil?) ? request.protocol : Toolbawks.default_protocol
            protocol = /(.*):\/\//.match(protocol)[1] if protocol.ends_with?("://")
            
            default_url_options[:protocol] = protocol
            
            Toolbawks.default_host = default_url_options[:host]
            Toolbawks.default_port = default_url_options[:port]
            Toolbawks.default_protocol = default_url_options[:protocol]

            default_url_options.delete(:port) if Toolbawks.default_port == false
          end
          yield
        ensure
          ::ActionController::UrlWriter.module_eval do
            default_url_options[:host]     = @old_default_url_options[:host]
            default_url_options[:port]     = @old_default_url_options[:port] if !@old_default_url_options[:port].nil? && @old_default_url_options[:port] != 80
            default_url_options[:protocol] = @old_default_url_options[:protocol]

            Toolbawks.default_host = default_url_options[:host]
            Toolbawks.default_port = default_url_options[:port]
            Toolbawks.default_protocol = default_url_options[:protocol]

            default_url_options.delete(:port) if Toolbawks.default_port == false
          end
        end
      end
    end
  end

  module ActionMailer
    def self.included(am)
      am.send(:include, ::ActionController::UrlWriter)
      ::ActionController::UrlWriter.module_eval do
        if ENV['RAILS_ENV'] == 'test'
          default_url_options[:host]     = 'example.com'
          default_url_options[:protocol] = 'http'
        else
          default_url_options[:host]     = 'localhost'
          default_url_options[:port]     = '3000'
          default_url_options[:protocol] = 'http'
        end
      end
    end
  end
end
