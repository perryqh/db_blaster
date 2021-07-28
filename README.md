[![codecov](https://codecov.io/gh/perryqh/db_blaster/branch/master/graph/badge.svg?token=ZMJVDAGX3K)](https://codecov.io/gh/perryqh/db_blaster)
# DbBlaster

Applications can use this gem as the first step in getting its data into an AWS Data Lake.

DbBlaster publishes changed database rows to AWS SNS. The first time `DbBlaster::PublishAllJob.perform_later` is ran,
the entire database will be incrementally published to SNS. Subsequent runs will publish rows whose `updated_at` column
is more recent than the last run

## Usage

Update `config/initializers/db_blaster_config.rb` to have valid AWS credentials, topics, and options.

Then schedule `DbBlaster::PublishAllJob.perform_later` to run periodically with something
like [sidekiq-cron](https://github.com/ondrejbartas/sidekiq-cron) or [whenever](https://github.com/javan/whenever)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'db_blaster'
```

And then execute:

```bash
$ bundle
```

Install Migrations:

```bash
$ rake db_blaster:install:migrations && rake db:migrate
```

Copy sample config file to rails project:

```bash
rails g db_blaster:install 
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
