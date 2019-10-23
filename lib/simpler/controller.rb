require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response
    attr_accessor :headers

    RENDER_OPTIONS = {
      status: "status",
      headers: "write_headers"
    }.freeze

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      # @params = env['simpler.params']
      @headers = {}
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      @request.params.merge(@request.env['simpler.params'])
      set_default_headers(self.class, action)
      send(action)
      set_headers
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    # def set_params(params)
    #   unless params.empty?
    #     params.each do |key, value|
    #       @request.update_param(key, value)
    #     end
    #   end
    # end

    def set_default_headers(controller, action)
      @response['Content-Type'] = 'text/html'
      @response['Controller#action'] = "#{controller}##{action}"
      @response['Params'] = "#{params}"
      @response['View_path'] = "#{@name}/#{action}.html.erb"
    end

    def set_headers
      @headers.each do |header, value|
        @response[header] = value
      end
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template, options = {})
      if template.class == Hash
        @request.env['simpler.render_option_value'] = template.values[0]
        @request.env['simpler.render_option'] = template.keys[0]
        options = template.drop(1).to_h
      else
        @request.env['simpler.template'] = template
      end

      do_options(options)

    end

    def do_options(options)
      options.each do |option, value|
        if RENDER_OPTIONS.include?(option)
          send(RENDER_OPTIONS[option], value)
        end
      end
    end

    def status(number)
      @response.status = number
    end

    def write_headers(headers)
      headers.each do |header, value|
        @headers[header] = value
      end
    end

    def no_page
      status 404
      @request.env['simpler.render_option'] = :public
      @request.env['simpler.render_option_value'] = 404
    end

  end
end
