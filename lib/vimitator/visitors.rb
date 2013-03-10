require 'vimitator/visitors/visitor'
Dir[File.join(File.dirname(__FILE__), "visitors/*_visitor.rb")].each do |file|
  require file[/vimitator\/visitors\/.*/]
end
