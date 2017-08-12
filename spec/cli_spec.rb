require 'populate_env/cli'

module PopulateEnv
  RSpec.describe CLI do
    describe '#start' do
      it 'outputs usage with no options' do
        expect { CLI.start(argv: []) }.to output(/Usage/).to_stdout
      end

      it 'prints help' do
        expect { CLI.start(argv: '-h') }.to output(/Usage/).to_stdout
        expect { CLI.start(argv: '--help') }.to output(/Usage/).to_stdout
        expect { CLI.start(argv: 'help') }.to output(/Usage/).to_stdout
      end

      it 'prints the version' do
        stub_const('PopulateEnv::VERSION', '42.0')
        expect { CLI.start(argv: '-v') }.to output(/42.0/).to_stdout
        expect { CLI.start(argv: '--version') }.to output(/42.0/).to_stdout
        expect { CLI.start(argv: 'version') }.to output(/42.0/).to_stdout
      end
    end
  end
end
