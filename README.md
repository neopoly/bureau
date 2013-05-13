# Bureau

Bureau provide a simple interface to build custom xlsx files.

[![Build Status](https://secure.travis-ci.org/neopoly/bureau.png?branch=master)](http://travis-ci.org/neopoly/bureau) [![Gem Version](https://badge.fury.io/rb/bureau.png)](http://badge.fury.io/rb/bureau) [![Code Climate](https://codeclimate.com/github/neopoly/bureau.png)](https://codeclimate.com/github/neopoly/bureau)

## Installation

Add this line to your application's Gemfile:

    gem 'bureau'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bureau

## Usage

### Short version

#### Implement a Table Presenter

Create a class, include Bureau::Table::Base and provide default_attributes and default_collection method.

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

Bureau registers a new mime type. You can render xlsx from your rails controller

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

### Long version

Create a class, include Bureau::Table::Base and provide 4 hook methods.

Required:

* default_attributes
* default_collection

Optional:

* default_row_presenter
* default_cell_presenter

#### Implement a Table Presenter

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

      private

      def default_row_presenter
        Bureau::Row::PersonPresenter
      end

      def default_cell_presenter
        Bureau::Cell::PersonPresenter
      end

    end
  end
end
```

#### Examples

All people with default attributes

```ruby
Bureau::Table::PeoplePresenter.new
```

All people with specific attributes

```ruby
Bureau::Table::PeoplePresenter.new(:attributes => [:firstname, :lastname])
```

All people with specific attributes and custom names

```ruby
Bureau::Table::PeoplePresenter.new(:attributes => {:firstname => 'First', :lastname => 'Last'})
```

Specific people with default attributes

```ruby
Bureau::Table::PeoplePresenter.new(:collection => [Person.first, Person.last])
```

Optional row presenter class

```ruby
Bureau::Table::PeoplePresenter.new(:row_preseter => Bureau::Row::PersonPresenter)
```

Optional cell presenter class

```ruby
Bureau::Table::PeoplePresenter.new(:cell_preseter => Bureau::Cell::PersonPresenter)
```

#### Implement a Row Presenter

Each item in your collection get wrapped in a Row Presenter.
In this case object is a person instance.

Methods that are not defined here will be forwared to object.
In this case birthday.

```ruby
module Bureau
  module Row
    class PersonPresenter
      include Bureau::Row::Base

      def firstname
        object.firstname.uppercase
      end

      def lastname
        object.lastname.lowercase
      end

    end
  end
end
```

#### Implement a optional Cell Presenter

Each attribute in your Row Presenter get wrapped in a Cell Presenter.

```ruby
module Bureau
  module Cell
    class PersonPresenter
      include Bureau::Cell::Base
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
