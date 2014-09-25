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
  c.app_id = "your-app-id"
  c.app_secret = "your-app-secret"
  c.org_url = "http://ORG-NAMESPACE.hullapp.io"
end
```

In Rails, you can include this in an initializer.

### Making API Calls

`get`, `put`, `post` and `delete` methods are directly available on Hull.

examples:

```rb
# Get the current app
Hull.get('app')

# Get the a list of comments on the current app (with pagination)
Hull.get('app/comments', limit: 10, page: 2)

# Update an existing object
Hull.put('app', { name: 'My Super App' })
```

with Hull entities :

```rb
entityId = Hull::Entity.encode('http://example.com')
#=>"~aHR0cDovL2V4YW1wbGUuY29t"

Hull.get(entityId)
Hull.put(entityId)
Hull.delete(entityId)

# Get comments on the Entity identified by 'http://example.com' 
Hull.get(entityId+'/comments')

# Decoding an encoded entity:
Hull::Entity.decode(entityId)
#=>'http://example.com'
```

### Making API calls as as a User

```rb
# From its user ID
Hull.as('51fa7afd09e50d11f1000002').get('me')

# Find a User based on his identity from an external service:

# Find user from his Twitter handle:
Hull.as('twitter:hull').get('me')

# Find user from his Faceboo ID
Hull.as('facebook:fb_uid').get('me')

# Find user from his ID in your app (BYOU)
Hull.as('external:3637').get('me')

# From a User in your database, with lazy creation (Checkout [Bring your own Users Documentation](http://hull.io/docs/users/byou))
userHash = {external_id:'1234', name:'Romain', email:'user@host.com'}
Hull.as(userHash).get('me')
```

### Getting the current User

`Hull.authenticate_user` allows you to retrieve the current User's ID.

#### Rails

```rb
class MyController < ApplicationController
  def current_hull_user_id
    @current_hull_user_id ||= Hull.authenticate_user(request.env)
  end

  def current_hull_user
    # You probably should cache this or record this information in a session
    # to avoid making calls to Hull's API on each request
    @current_hull_user ||= Hull.get(current_hull_user_id)
  end
  
end
```


### Bring your own users

Using JWT, you can use Hull with Users from your system.
To use this feature, you just have to add a `accessToken` key at the initialization of hull.js. Read more at http://hull.io/docs/users/byou

In your view :

```html
<script>
  Hull.init({
    appId:  "<%= Hull.app_id %>",
    orgUrl: "<%= Hull.org_url %>",
    accessToken: "<%= Hull.user_token({external_id: "123", email: "bill@hullapp.io", name: "Bill Evans" })  %>"
  });
</script>
```

### Hooks

[Hooks](hull.io/docs/libraries/#hooks) allow you to be notified every time an
object in your app is created, updated or deleted.

```ruby
require 'hull/middlewares/hook'

# path option default is '/__hull-hook__'
use Hull::Middlewares::Hook, path: '/hullook', secret: ENV['HULL_APP_SECRET'] do |event, request|
  # Do something with event
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
