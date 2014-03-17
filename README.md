# Rinfo

[![Gem Version](https://badge.fury.io/rb/rinfo.png)](http://badge.fury.io/rb/rinfo) [![Build Status](https://travis-ci.org/rafecolton/rinfo.png?branch=master)](https://travis-ci.org/rafecolton/rinfo) [![Dependency Status](https://gemnasium.com/rafecolton/rinfo.png)](https://gemnasium.com/rafecolton/rinfo)

## Usage

Ever wish you could have quick and easy access to release information
("rinfo") about your Rails application's latest release?  Well now you
can!

Rinfo adds the following route to your application:

```ruby
get '/rinfo.json'
```

Accessing your `rinfo.json` page will product something like this:

```javascript
{
  Deployed By: "Rafe Colton",
  Deployed At: "2014-03-17 15:18:35 -0700",
  Rails Env: "development",
  Branch: "master",
  Rev: "018f44579795167c56066c013b4b18e196142ecb"
}
```

It's as easy as that!

## Installation

To add `rinfo` to your Rails application, add the `rinfo` gem to your `Gemfile`:

```ruby
gem 'rinfo'
```

Then, to install the gem:

```bash
bundle install
```

## Configuring

Rinfo's functionality is extremely simple, and it doesn't require any
configuration, but should you desire, it is configurable.

Your configuration file `config/initializers/rinfo.rb` would look
something like this:

```ruby
# config/initializers/rinfo.rb
Rinfo.env_blacklist = :staging, :production
```

The `env_blacklist` attribute is a list of environments such that if it
includes your `RAILS_ENV`, the `/rinfo.json` route will return a `404`
response insetad of a `JSON` blob.  The arguments provided can be a
string, an array, or a comma separated list, and each entry can be
either a string or a symbol.  The default blacklist is `[:prod,
:production]`

**NOTE:** There is one special value `:all`, which, if included in your
list, will prevent `rinfo.json` from showing up entirely, regardless of
your `RAILS_ENV`
