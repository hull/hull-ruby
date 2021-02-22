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

```ruby
Hull.configure do |c|
  c.app_id = "5b472f6b35632446d600181c"
  c.app_secret = "co891467hro287h4o2h4o2i34785o23"
  c.organization = "example.hullapp.io"
end
```

In Rails, you can include this in an initializer.


### Making API calls as as a User

```rb
# From its user ID
Hull.as('51fa7afd09e50d11f1000002').get('me')


# From a User in your database, with lazy creation (Check the Identity resolution section here https://www.hull.io/docs/data_lifecycle/ingest/)
identity = { external_id:'1234', email:'user@host.com' }
Hull.as(identity).get('me')
```

### Capturing user Traits and track Events

For users

```
user = Hull.as_user(email: 'user@example.com')
user.traits({ name: 'Bob', age: 21 })
user.track('Visited Page', { url: 'http://www.hull.io' })
```


For accounts

```
account = Hull.as_account(domain: 'hull.op')
user.traits({ name: 'Hull inc' })
```




## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
