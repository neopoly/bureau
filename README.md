# Bureau

Bureau provide a simple interface to build custom xlsx files.

## Installation

Add this line to your application's Gemfile:

    gem 'bureau'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bureau

## Usage

### Short version

1. Create a new class that represent the table.
2. Include Bureau::Table::Base module and provide 2 methods.

```ruby
module Bureau
  module Table
    class PeoplePresenter

      include Bureau::Table::Base

      def default_attributes
        {
          'firstname' => 'First name',
          'lastname' => 'Last name',
          'birthday' => 'Birthday'
        }
      end

      def default_collection
        Person.all
      end

    end
  end
end
```

3. Return a xlsx file.

```ruby
table = Bureau::Table::PeoplePresenter.new

table.render
```

4. Bureau register a new mime type - render xlsx from your controller.

```ruby
class SomeController < ApplicationController

  def export
    table = Bureau::Table::PeoplePresenter.new

    respond_to do |format|
      format.xlsx { render :text => table.render }
    end
  end

end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
