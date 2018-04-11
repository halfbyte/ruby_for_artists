puts "patch the pain away"
require 'mittsu/renderers/glfw_lib'
module Mittsu
  module GLFWLib
    class MacOS
      puts "yip"
      def file
        puts "ffoo"
        puts self.class.inspect
        'libglfw.dylib'
      end
    end
  end
end
