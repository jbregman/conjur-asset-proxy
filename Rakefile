require "bundler/gem_tasks"

desc "Update copyright headers"
task :headers do
  require 'rubygems'
  require 'copyright_header'

  args = {
    :license => 'MIT',
    :copyright_software => 'Conjur CLI proxy plugin',
    :copyright_software_description => "Simple HTTP proxy which adds Conjur authentication headers",
    :copyright_holders => ['Conjur Inc.'],
    :copyright_years => ['2014'],
    :add_path => 'lib',
    :output_dir => './'
  }

  command_line = CopyrightHeader::CommandLine.new( args )
  command_line.execute
end

task :jenkins do
  # TODO
  puts "No tests, maybe add some specs?"
end
