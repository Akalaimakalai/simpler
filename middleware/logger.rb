require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || File.expand_path('../log/app.log', __dir__))
    @app = app
  end

  def call(env)
    @logger.info(request(env))
    @status, @headers, @body = @app.call(env)
    @logger.info(handler)
    @logger.info(parameters)
    @logger.info(response)
    [@status, @headers, @body]
  end

  private

  def request(env)
    "Request: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}?#{env['QUERY_STRING']}"
  end

  def handler
    "Handler: #{@headers['Controller#action']}"
  end

  def parameters
    "Parameters: #{@headers['Params']}"
  end

  def response
    "Response: #{@status} [#{@headers['Content-Type']}] #{@headers['View_path']}"
  end
end
