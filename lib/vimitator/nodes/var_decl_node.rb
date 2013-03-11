module Vimitator
  module Nodes
    class VarDeclNode < Node
      attr_accessor :name, :type
      def initialize(name, value, constant = false)
        super(value)
        @name = name
        @constant = constant   # in VimL vars can be :help :lockvar
      end

      def constant?; @constant; end
      def variable?; !@constant; end
    end
  end
end
