# Hull Ruby client

## Installation

Add this line to your application's Gemfile:

    gem 'hullio'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hullio

## Usage

### Configuration

    Hull.configure do |c|
      c.app_id      = "your-app-id"
      c.app_secret  = "your-app-secret"
      c.endpoint    = "http://ORG-NAMESPACE.hullapp.io"
    end

### Making API Calls

`get`, `put`, `post` and `delete` methods are directly available on Hull.

examples: 

    # To get the current app
    Hull.get('app')

    # To get the a list of comments on the current app (with pagination)
    Hull.get('app/comments', limit: 10, page: 2)

    # To update an existing object
    Hull.put('app', { name: 'My Super App' })

with Hull entities :

    Hull.get('entity', { uid: 'http://example.com' })
    Hull.put('entity', { uid: 'http://example.com', name: 'My super Page' })
    Hull.delete('entity', { uid: 'http://example.com' })


### Bring your own users

In addition to providing multiple social login options, Hull allows you to create and authenticate users that are registered within your own app.

To use this feature, you just have to add a `userHash` key at the initialization of hull.js : 

In you view : 

    <script>
      Hull.init({
        appId:  "<%= Hull.app_id %>",
        orgUrl: "<%= Hull.endpoint %>",
        userHash: "<%= Hull.user_hash({ id: "123", email: "bill@hullapp.io", name: "Bill Evans" })  %>"
      });
    </script>


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
