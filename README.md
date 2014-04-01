# Completeness

Completeness is a way to add completeness progress (like in LinkedIn) into your application.

## Installation

Add this line to your application's Gemfile:

    gem 'completeness'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install completeness

## Usage

It's extremely simple. Add `Completeness::Model` module into your model and define weights for each attribute.

```ruby
class MyModel < Struct.new(:name, :email, :phone, :desctiption, :dob)
  include Completeness::Model
  
  completeness weight: 20 do
    field :name, required: true
    field :email, weight: 15, required: true
    field :phone, weight: 15
    field :description, weight: 5
    field :dob, weight: 10, check: ->(object, value){ value.is_a?(Date) && value.past? }
  end
end
```

It will add into your model these methods

- `completeness_spec` - this is the `Completeness::Specification` object which contains all specification for the model. See [specification.rb](lib/completeness/specification.rb) for more details.
- `completed?` - it returns `true` if all required attributes are completely filled, otherwise returns `false`.
- `completed_percent` - it returns percentage of completeness the object. It will be integer value between 0 and 100.
- `completed_weight` - it returns summary weight of all attributes what was being completed.

The method `completeness` can take an options hash. It's default options for all fields what will be defined in the block. Available options are:

- `:weight` - default weight.
- `:required` - set `true` if you are going to mark all fields as required.
- `:check` - lambda or another object which respond to `call`. It rewrites of completeness check method. You can define a custom method. It should take two arguments (object and checked value) and return `true` or `false`. Default method is `->(obj, value){ value.present? }`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
