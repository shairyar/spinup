module Spinup
  def self.logger
    # Create a Logger that prints to STDOUT
    Logger.new(STDOUT)
  end
end
