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

#### Implement a Table Presenter

Create a class, include Bureau::Table::Base and provide default_attributes and default_collection method.

```ruby
class PeopleTablePresenter

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
      format.xlsx { render :text => PeopleTablePresenter.new.render }
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

#### Implement a Table Presenter with hook methods

```ruby
class PeopleTablePresenter

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
    PersonRowPresenter
  end

  def default_cell_presenter
    PersonCellPresenter
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
PeopleTablePresenter.new
```

All people with specific attributes

```ruby
PeopleTablePresenter.new(:attributes => [:firstname, :lastname])
```

All people with specific attributes and custom names

```ruby
PeopleTablePresenter.new(:attributes => {:firstname => 'First', :lastname => 'Last'})
```

Specific people with default attributes

```ruby
PeopleTablePresenter.new(:collection => [Person.first, Person.last])
```

Optional row presenter class

```ruby
class PersonRowPresenter
  include Bureau::Row::Base
end

PeopleTablePresenter.new(:row_preseter => PersonRowPresenter)
```

Optional cell presenter class

```ruby
class PersonCellPresenter
  include Bureau::Cell::Base
end

PeopleTablePresenter.new(:cell_preseter => PersonCellPresenter)
```

Optional renderer class

```ruby
class PersonRenderer < Bureau::Renderer::Base
end

PeopleTablePresenter.new(:renderer => PersonRenderer)
```

Optional sheet name

```ruby
PeopleTablePresenter.new(:name => "MySpecialSheet")
```

Only use specific features - or fallback to all avaliable features

```ruby
PeopleTablePresenter.new(:features => [ Bureau::Features::Filter, Bureau::Features::Docked ])
```

Use can also provide any Object that responds to +call+ as a feature

```ruby
filter = proc { |renderer| renderer.worksheet.auto_filter = renderer.worksheet.dimension.sqref }
PeopleTablePresenter.new(:features => [ filter ])
```

#### Implement a Row Presenter

Each item in your collection get wrapped in a Row Presenter.
In this case object is a person instance.

Methods that are not defined here will be forwared to object.
In this case birthday is accessible through object.

```ruby
class PersonRowPresenter
  include Bureau::Row::Base

  def firstname
    object.firstname.uppercase
  end

  def lastname
    object.lastname.lowercase
  end
end
```

#### Implement a Cell Presenter

tbd

#### Implement a Renderer

tbd

#### Implement own Features

tbd

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
