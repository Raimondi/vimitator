#!/usr/bin/env rake
require "rubygems"
require "bundler/gem_tasks"
require "rake"

task :default => [:rex, :racc]

task :rex  => ['lib/vimitator/scanner.rb']
task :racc => ['lib/vimitator/parser.rb']

file 'lib/vimitator/scanner.rb' => ['lib/vimitator/scanner.rex'] do |t|
  sh "rex -o #{t.name} #{t.prerequisites.join(' ')}"
end

file 'lib/vimitator/parser.rb' => ['lib/vimitator/parser.y'] do |t|
  sh "racc -t -v -o #{t.name} #{t.prerequisites.join(' ')}"
end

require 'rake/testtask'
task :test => [:rex, :racc]
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
