#!/usr/bin/env rake
require "bundler/gem_tasks"

task :default => [:test]

file 'lib/vimitator/parser.rb' => ['lib/vimitator/parser.racc'] do |t|
  sh "racc -t -v -o #{t.name} #{t.prerequisites.join(' ')}"
end

task :test => ['lib/vimitator/parser.rb', 'lib/vimitator/scanner.rb'] do |t|
  errors = []
  puts "----"
  puts "Test: #{t.name}"
  sh "cat #{t.name}"
  puts "----"
  sh "./viml < #{t.name}" || errors << t.name
  puts "Test with errors: #{errors}" unless errors.empty?
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
