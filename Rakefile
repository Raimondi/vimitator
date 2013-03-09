#!/usr/bin/env rake
require "rubygems"
require "bundler/gem_tasks"
require "rake"

task :default => [:rex, :racc, :test]

task :rex  => ['lib/vimitator/scanner.rb']
task :racc => ['lib/vimitator/parser.rb']

file 'lib/vimitator/scanner.rb' => ['lib/vimitator/scanner.rex'] do |t|
  sh "rex -o #{t.name} #{t.prerequisites.join(' ')}"
end

file 'lib/vimitator/parser.rb' => ['lib/vimitator/parser.racc'] do |t|
  sh "racc -t -v -o #{t.name} #{t.prerequisites.join(' ')}"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end


# test: lib/vim/parser.rb
# 	@for t in test/*;\
# 		do\
# 		echo --------------------------------------;\
# 		echo "Test: $$t";\
# 		cat $$t;\
# 		echo --------------------------------------;\
# 		./viml < $$t || errors="$$errors $$t";\
# 	done;\
# 	echo "Tests with errors:$$errors"

# test/%: lib/vim/parser.rb
# 	@echo --------------------------------------
# 	@echo "Test: $@"
# 	@cat $@
# 	@echo --------------------------------------
# 	./viml < $@
