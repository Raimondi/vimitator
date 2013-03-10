require 'vimitator/nodes/node'
Dir[File.join(File.dirname(__FILE__), "nodes/*_node.rb")].each do |file|
  require file[/vimitator\/nodes\/.*/]
end
