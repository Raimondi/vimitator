require 'vimitator/nodes/if_node'

module Vimitator
  module Nodes
    class ConditionalNode < IfNode
      def initialize(test, true_block, else_block)
        super
      end
    end
  end
end
