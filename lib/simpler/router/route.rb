module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = []
      end

      def match?(method, path)
        original_arr = @path.split('/').drop(1)
        given_arr = path.split('/').drop(1)
        
        @method == method && (path == @path || any_params?(original_arr, given_arr))
      end

      def any_params?(original_arr, given_arr)
        return false if original_arr.length != given_arr.length

        original_arr.each_with_index do |value, index|
          if value[0] == ':'
            @params << [value, given_arr[index]]
          else
            return false if value != given_arr[index]
          end
        end
      end
    end
  end
end
