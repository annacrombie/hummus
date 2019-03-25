# Settei

Settings for ruby objects

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'settei'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install settei

## Usage

```ruby
class CoolClass
  include Settei.cfg(
    path: '/a/cool/path',
    value: 93,
    do_this: true
  )
end

CoolClass.path #=> '/a/cool/path'
CoolClass.value #=> 93
CoolClass.do_this? #=> true

CoolClass.dont_do_this
CoolClass.do_this? #=> false

CoolClass.value = 'hello'
# TypeError, expecting boolean
```
