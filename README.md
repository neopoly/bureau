# Bureau

Bureau provides a simple interface to build custom xlsx files in Rails apps.

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

#### Table

Create a class, include Bureau::Table::Base and provide default_attributes and default_collection method.

```ruby
class PeopleTable

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
```

Bureau registers a xlsx mime type. You can render xlsx direct from your rails controller.

```ruby
class SomeController < ApplicationController

  def export
    respond_to do |format|
      format.xlsx { render :text => PeopleTable.new.render }
    end
  end

end
```

### Long version

* Create a class that represent the table.
* Include Bureau::Table::Base module.
* Provide several hook methods.

Required:

* default_attributes
* default_collection

Optional:

* default_row_presenter
* default_cell_presenter
* default_renderer
* default_name
* default_features

#### Table

```ruby
class PeopleTable

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

  def default_row_presenter
    PersonRow
  end

  def default_cell_presenter
    PersonCell
  end

  def default_renderer
    PersonRenderer
  end

  def default_name
    "MySheetName"
  end

  def default_features
    [:colorize_cells_in_green_and_pink]
  end

end
```

#### Or pass hooks during runtime

All people with default attributes

```ruby
PeopleTable.new
```

All people with specific attributes

```ruby
PeopleTable.new(:attributes => [:firstname, :lastname])
```

All people with specific attributes and custom names

```ruby
PeopleTable.new(:attributes => {:firstname => 'First', :lastname => 'Last'})
```

Specific people with default attributes

```ruby
PeopleTable.new(:collection => [Person.first, Person.last])
```

Optional row presenter class

```ruby
class PersonRow
  include Bureau::Row::Base
end

PeopleTable.new(:row_preseter => PersonRow)
```

Optional cell presenter class

```ruby
class PersonCell
  include Bureau::Cell::Base
end

PeopleTable.new(:cell_preseter => PersonCell)
```

Optional renderer class

```ruby
class PersonRenderer < Bureau::Renderer::Base
end

PeopleTable.new(:renderer => PersonRenderer)
```

Optional sheet name

```ruby
PeopleTable.new(:name => "MySpecialSheet")
```

Only use specific features - or fallback to all avaliable features

```ruby
PeopleTable.new(:features => [ Bureau::Features::Filter, Bureau::Features::Docked ])
```

Use can also provide any Object that responds to +call+ as a feature

```ruby
filter = proc { |renderer| renderer.worksheet.auto_filter = renderer.worksheet.dimension.sqref }
PeopleTable.new(:features => [ filter ])
```

#### Row

Each item in your collection get wrapped in a Row.
In this case object is a person instance.

Methods that are not defined here will be forwared to object.
In this case birthday is accessible through object.

```ruby
class PersonRow
  include Bureau::Row::Base

  def firstname
    object.firstname.uppercase
  end

  def lastname
    object.lastname.lowercase
  end
end
```

#### Cell

tbd

#### Renderer

tbd

#### Features

tbd

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
