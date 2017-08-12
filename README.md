# populate-env

A command-line tool for populating environment variables.


## Installation

    gem install populate-env

## Usage

### Heroku

Heroku apps can describe which environment variables they need via an [app.json manifest](https://blog.heroku.com/introducing_the_app_json_application_manifest):

```json
{
  "env": {
    "BRAND_COLOUR": "smaragdine",
    "AMAZING_WEB_SERVICES_TOKEN": {
      "description": "A required token for interacting with Amazing Web Services."
    },
    "WEB_CONCURRENCY": {
      "description": "The number of processes to run.",
      "value": "5"
    },
    "LEATHER_SEATS": {
      "description": "Optional flag to enable leather seats.",
      "required": false
    },
    "SECRET_TOKEN": {
      "description": "A secret key for verifying the integrity of signed cookies.",
      "generator": "secret"
    }
  },
  "environments": {
    "test": {
      "AMAZING_WEB_SERVICES_TOKEN": "mock"
    }
  }
}
```

Given this file, running the following command will generate a `.env` file:

    $ populate-env heroku
    
    BRAND_COLOUR: "smaragdine"
      => using default from app.json
    
    AMAZING_WEB_SERVICES_TOKEN: "token-from-heroku-app"
      => using value from detected Heroku remote "dev"
    
    WEB_CONCURRENCY: "5"
      => using default from app.json
    
    LEATHER_SEATS: (skipped)
      => no value available
    
    SECRET_TOKEN: "1d8505..."
      => generated secret (32 chars)
    
    WEB_CONCURRENCY: "5"
      => using default from app.json

The resulting `.env` file looks like this:

```shell
BRAND_COLOUR=smaragdine

# A required token for interacting with Amazing Web Services.
AMAZING_WEB_SERVICES_TOKEN=token-from-heroku-app

# The number of processes to run.
WEB_CONCURRENCY=5

# Optional flag to enable leather seats.
# LEATHER_SEATS=

# A secret key for verifying the integrity of signed cookies.
SECRET_TOKEN=1d8505fa8172fae3b17f5e57568406b8
```

Any required environment variable not currently in your ENV will be populated by trying each of the following:

1. Using the default value, as specified in your `app.json`
2. Generating a pseudorandom secret (for environment variables marked with `generator: secret`)
3. Using the values from your remote Heroku instance
4. Prompting you for a missing, required value

The command above is equivalent to the following options:

    populate-env heroku \
        --manifest app.json \
        --manifest-environment production \
        --destination .env \
        --skip-local-env \
        --heroku-config \
        --generate-secrets \
        --prompt-missing

#### Remote Heroku config

If your project has a git remote with `heroku.com` in the URL, `populate-env`
will detect it and use it to retrieve remote configuration. If you don't want
this behaviour, you can skip it with:

    populate-env heroku --no-heroku-config

If you have multiple Heroku remotes or want to specify your Heroku app
explicitly, you can use either:

    populate-env heroku --heroku-remote staging # or
    populate-env heroku --heroku-app spronking-wildebeest-42

For full options, run:

    populate-env heroku --help

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Aupajo/populate-env. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Populate::Env project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Aupajo/populate-env/blob/master/CODE_OF_CONDUCT.md).
