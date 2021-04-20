require 'aws-sdk-ec2'
require 'logger'
require 'pry'
require 'ruby-progressbar'
require 'table_print'
require 'yaml'
require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.push_dir('./lib')
loader.setup
