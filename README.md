# Hull Ruby client

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'hullio'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hullio

## Usage

### Configuration

Hull.configure do
  app_id      = "your-app-id"
  app_secret  = "your-app-id"
  endpoint    = "http://ORG-NAMESPACE.alpha.hullapp.io"
end

### Making API Calls

`get`, `put`, `post` and `delete` methods are directly available on Hull.

examples: 

    # To get the current app
    Hull.get('app')

    # To get on object
    



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
