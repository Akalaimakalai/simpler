require_relative 'router/route'

module Simpler
  class Router

    REG = /[0-9]/

    def initialize
      @routes = []
      # @routes_params_indexes = []
      # @routes_params_names = []
    end

    def get(path, route_point)
      add_route(:get, path, route_point)
    end

    def post(path, route_point)
      add_route(:post, path, route_point)
    end

    def route_for(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      path = env['PATH_INFO']

      @routes.find { |route| route.match?(method, path) }
    end

    private

    def add_route(method, path, route_point)
      # find_params(path)
      step1 = path.split('/')
      step2 = step1.each { |i| i.replace("#{REG}") if i.include?(':') }
      final_step = step2.join('/')
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      route = Route.new(method, final_step, controller, action)

      p step1
      p step2
      p final_step

      @routes.push(route)
    end

    # def find_params(path)
    #   @routes_params_indexes.push(path.split('/').find_index { |i| i.include?(':') })
    #   @routes_params_names.push(path.split('/').select { |i| i.include?(':') })
    # end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

    # def add_params(route)
    #   i = @routes.find_index(route)
    #   params_names = @routes_params_names[i]
    #   params_values = []
    #   a = route.split('/')
    #   b = @routes_params_indexes[i]
    #   b.each { |i| params_values << a(i) }
    # end

  end
end
