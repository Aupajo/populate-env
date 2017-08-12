# populate-env

A command-line tool for populating environment variables.

## Installation

    gem install populate-env

## Goals

For a Heroku-based project with an [app.json manifest](https://blog.heroku.com/introducing_the_app_json_application_manifest), run:

    populate-env heroku

This will:

* Parse your project's `app.json` file for required environment variables
* Create a `.env` file, attempting to populate each variable in the following order:
  * The value of an identically-named local environment variable
  * The default value as specified in `app.json`
  * A psuedo-randomly generated secret (for variables marked with `generate: secret`)
  * The environment variable as configured in Heroku (if a Heroku git remote is set)
  * A user-entered prompt

This command should be equivalent to the following flags:

    populate-env heroku \
        --manifest app.json \
        --output .env \
        --local-env \
        --heroku-config \
        --generate-secrets \
        --prompt-missing

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
