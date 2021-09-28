![Coverage Badge](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/perryqh/be2fa5413124206272dbc700f3201f5a/raw/db_blaster__master.json)
# DbBlaster
![Image of DB to SNS](https://lucid.app/publicSegments/view/c70feed3-2f48-46ee-8734-423474488feb/image.png)

DbBlaster can either publish changed database rows to AWS SNS or push the changes to S3. The first time `DbBlaster::PublishAllJob.perform_later` is ran,
the entire database will be incrementally published. Subsequent runs will publish rows whose `updated_at` column
is more recent than the last run.

Consuming the published messages is functionality not provided by DbBlaster. 

## Usage

Update `config/initializers/db_blaster_config.rb` with valid AWS credentials and options. Either `sns_topic` or `s3_bucket` must be set!

Schedule `DbBlaster::PublishAllJob.perform_later` to run periodically with something
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
