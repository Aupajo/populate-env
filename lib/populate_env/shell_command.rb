module PopulateEnv
  module ShellCommand
    def self.run(command)
      `#{command}`
    end
  end
end
