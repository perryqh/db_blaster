# DbBlaster
Publish database changes to AWS SNS

## Usage
```ruby
DbBlaster.configure do |config|
  config.sns_topic = 'the-topic' # SNS topic to receive database changes
  config.aws_access_key = 'access-key'
  config.aws_access_secret = 'secret'
  config.aws_region = 'region'
  config.source_tables = [{ name: 'table-1',
                            ignored_columns: [],
                            batch_size: 100 }] # tables to be pushed to SNS
end
```
Then schedule `DbBlaster::PublishAllJob.perform_later` to run
periodically with something like [sidekiq-cron](https://github.com/ondrejbartas/sidekiq-cron) or [whenever](https://github.com/javan/whenever)


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'db_blaster'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install db_blaster
```
Install Migrations:
```bash
$ rake db_blaster:install:migrations && rake db:migrate
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
