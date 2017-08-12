require 'tmpdir'

module PopulateEnv
  RSpec.describe Heroku do
    describe '.call' do
      it 'populates a .env file' do
        output = StringIO.new
        input = StringIO.new

        options = Heroku::Options.new(
          manifest_environment: 'production',
          manifest: "#{__dir__}/fixtures/heroku/complex-app.json",
          secret_generator: -> { 'topsecret' },
          generate_secrets: true,
          use_heroku_config: true,
          output: output,
          input: input,
          prompt_missing: true,
          local_env: { 'ENV_VAR' => 'present' }
        )

        Dir.mktmpdir do |tmpdir|
          filesystem = Pathname(tmpdir)
          env_file = filesystem.join('.env')

          options.destination = env_file
          
          input.write('provided')
          input.rewind

          expect(ShellCommand).to receive(:run).with('git remote --verbose').and_return <<~REMOTES
            heroku	https://git.heroku.com/spronking-calamity-15603.git (fetch)
            heroku	https://git.heroku.com/spronking-calamity-15603.git (push)
          REMOTES
          
          expect(ShellCommand).to receive(:run).with('heroku config --json --remote heroku').and_return <<~EXTERNAL_CONFIG
            {
              "REMOTE": "obtained"
            }
          EXTERNAL_CONFIG

          Heroku.call(options)

          output.rewind
          expect(output.read.strip).to eq <<~PROMPT.strip
            SIMPLE: "value"
              => using default from complex-app.json

            ENV_VAR: (skipped)
              => found in local ENV

            OVERRIDDEN: "development"
              => using default from complex-app.json
            
            SECRET: "topsecret"
              => generated secret

            OPTIONAL: (skipped)
              => no value available
            
            REMOTE: "obtained"
              => using value from Heroku ("--remote heroku")

            MISSING:
              A required, missing setting

              => Please provide a value for MISSING:
          PROMPT

          expect(env_file.read).to eq <<~DOTENV
            SIMPLE=value

            OVERRIDDEN=development

            # A secret
            SECRET=topsecret

            # An optional setting
            # OPTIONAL=
            
            # A setting fetched from a Heroku remote
            REMOTE=obtained

            # A required, missing setting
            MISSING=provided
          DOTENV
        end
      end
    end
  end
end
