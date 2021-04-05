require 'zeitwerk'
require 'logger'
require 'aws-sdk-ec2'
require 'yaml'
require 'table_print'
require 'pry'

loader = Zeitwerk::Loader.new
loader.push_dir('./lib')
loader.setup
