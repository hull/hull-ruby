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
      c.org_url     = "http://ORG-NAMESPACE.hullapp.io"
    end

In Rails, you can include this in an initializer.

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


### Making API calls as as a User

From its user ID

        Hull.as('51fa7afd09e50d11f1000002').get('me')

From a user UID

        Hull.as('twitter:hull').get('me')
        Hull.as('external:3637').get('me')



### Getting the current User

Hull.authenticate_user allows you to get the current User's ID.

#### Rails


        class MyController < ApplicationController
            def current_hull_user_id
                @current_hull_user_id ||= Hull.authenticate_user(request.env)
            end
            def current_hull_user
                // You probably should cache this or record this information in a session
                // to avoid making calls to Hull's API on each request
                @current_hull_user ||= Hull.get(current_hull_user_id)
            end
        end

### Compiling widgets and templates with Rails' Assets Pipeline

Load `handlebars_assets` in your Gemfile as part of the assets group

    group :assets do
      gem 'handlebars_assets'
    end


Place your widgets inside the `app/assets/javascripts` dir.

    app
    ├── assets
    │   ├── javascripts
    │   │   ├── application.js
    │   │   └── hello
    │   │       ├── hello.hbs
    │   │       └── main.js

And require the in your `application.js` file :


    //= require handlebars
    //= require_tree .


### Bring your own users

In addition to providing multiple social login options, Hull allows you to create and authenticate users that are registered within your own app.

To use this feature, you just have to add a `userHash` key at the initialization of hull.js :

In you view :

    <script>
      Hull.init({
        appId:  "<%= Hull.app_id %>",
        orgUrl: "<%= Hull.org_url %>",
        userHash: "<%= Hull.user_hash({ id: "123", email: "bill@hullapp.io", name: "Bill Evans" })  %>"
      });
    </script>

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
