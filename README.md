# NestedGenerators

[![Gem Version][GV img]][Gem Version]
[![Build Status][BS img]][Build Status]
[![Coverage Status][CS img]][Coverage Status]

Ruby on Rails generators for `ServiceObject` and `QueryObject` classes and their
corresponding unit test files for RSpec framework. Easily extendable.

## Introduction

Ruby on Rails enforces unique class names usage inside its `app` directory.

Following framework's convention to place different class patterns in their own
folders, the gem extends autoloaded `app` directory with other types (like
[Sidekiq][sidekiq] does with its `app/workers` and
`rails generate sidekiq:worker` generator):

```
app
|___controllers
|       application_controller.rb
|       .
|___jobs
|       application_job.rb
|       .
|___models
|       application_record.rb
|       .
|___queries
|       .
|___services
        application_service.rb
```

## ServiceObject Generator

As [an old but gold article by CodeClimate][codeclimate article]
states in their second point _2. Extract Service Objects_, there are some
criteria for when to use `ServiceObject` pattern - read it, its worth it.

### Basic usage

The gem gives you an ability to generate file structure for your
`ServiceObject` classes via CLI, with a single empty `public` method `call`.

The simplest:

```
$ rails generate service potato_peel
```

or

```
$ rails generate service PotatoPeel
```

results in following:

```
app
|___services
|      application_service.rb
|      potato_peel_service.rb
spec
    potato_peel_service_spec.rb
```

so it gives us three files in total:

**file 1:** _app/services/application_service.rb_
```
# frozen_string_literal: true

module Services
  class ApplicationService
    def self.call(*args)
      new(*args).call
    end
  end
end


```

The first file contains `ApplicationService`, which simply allows us to call
the `ServiceObject` classes without invoking their `.new` method - simply pass
all your wannabe instance variables to the `.call` method directly:

```
PotatoPeelService.call(difficulty: 'medium')
```

results in the new instance of `PotatoPeelService` with an instance variable
`@difficulty = 'medium'`.

**file 2:** _app/services/potato_peel_service.rb_
```
# frozen_string_literal: true

module Services
  class PotatoPeelService < ApplicationService
    def initialize
    end

    def call
    end
  end
end

```

The second file contains `PotatoPeelService`, which inherits from the
`ApplicationService` and has two empty methods: `initialize` and `call`.

As you have probably noticed, `ServiceObjects` are placed in `Services` module.
I like to keep those that way (hence _opinionated_), but thankfully Rails is
smart enought to find their invocation without `Services::` prefix, so you can
use both:

```
Services::PotatoPeelService.call
# and
PotatoPeelService.call
```

**file 3:** _spec/services/potato_peel_service_spec.rb_
```
# frozen_string_literal: true

RSpec.describe Services::PotatoPeelService do
  describe '#call' do
    pending 'add some examples to (or delete) spec/services/potato_peel_service_spec.rb#call'
  end
end

```

The third file contains almost empty struture to test our brand new
`PotatoPeelService`, with single `describe` block for the `call` method.

## Generating methods

The gem allows us to predefine methods for our `ServiceObjects`.

```
rails generate service potato_peel public:fast protected:deadline private:sharpen_knife
```

results in:

**file 1:** _app/services/potato_peel_service.rb_
```
# frozen_string_literal: true

module Services
  class PotatoPeelService < ApplicationService
    def initialize
    end
    
    def call
    end

    def fast
    end

    protected

    def deadline
    end

    private

    def sharpen_knife
    end
  end
end
```

which is the same file structure as before with additional class methods scoped
accordingly.

**file 2:** _spec/services/potato_peel_service_spec.rb_
```
# frozen_string_literal: true

RSpec.describe Services::PotatoPeelService do
  describe '#call' do
    pending 'add some examples to (or delete) spec/services/potato_peel_service_spec.rb#call
  end
  
  describe '#fast' do
    pending 'add some examples to (or delete) spec/services/potato_peel_service_spec.rb#fast
  end
end
```

and the `_spec.rb` file contains an additional `describe` block for the `public`
method passed.

## Submodules

It is possible to generate service objects with additional namespaces -
generator syntax is the same as with Rails controllers:

```
$ rails generate service peelers/potato
```

or even deeper, spearating your modules with backslashes `/`.

The command call above results in the following:


```
app
|___services
|   |   application_service.rb
|   |___peelers
|           potato_service.rb
spec
|___peelers
        potato_service_spec.rb  
```

**file 1:** _app/services/peelers/potato_service.rb_
```
# frozen_string_literal: true

module Services
  module Peelers
    class PotatoService < ApplicationService
      def initialize
      end

      def call
      end
    end
  end
end

```

**file 2:** _spec/services/peelers/potato_service_spec.rb_
```
# frozen_string_literal: true

RSpec.describe Services::Peelers::PotatoService do
  describe '#call' do  
    pending 'add some examples to (or delete) spec/services/peelers/potato_service_spec.rb#call
  end
end

```

And you can pass them `public`, `protected` and `private` methods too, as
described in Generating methods section:

```
$ rails generate service peelers/potato public:fast
```

results in:

**file 1:** _app/services/peelers/potato_service.rb_
```
# frozen_string_literal: true

module Services
  module Peelers
    class PotatoService < ApplicationService
      def initialize
      end

      def call
      end

      def fast
      end
    end
  end
end

```

and corresponding:

**file 2:** _spec/services/peelers/potato_service_spec.rb_
```
# frozen_string_literal: true

RSpec.describe Services::Peelers::PotatoService do
  describe '#call' do
    pending 'add some examples to (or delete) spec/services/peelers/potato_service_spec.rb#call'
  end

  describe '#fast' do
    pending 'add some examples to (or delete) spec/services/peelers/potato_service_spec.rb#fast'
  end
end

```

## QueryObject Generator

Quoting the golden article mentioned before:

> For complex SQL queries littering the definition of your ActiveRecord subclass
(either as scopes or class methods), consider extracting query objects.


### Basic usage

The gem gives you an ability to generate classes structure for your
`QueryObject` classes via CLI.

The simplest:

```
$ rails generate query rotten_potatoes
```

or

```
$ rails generate query rotten_potatoes
```

results in following:

```
app
|___queries
|       rotten_potatoes_query.rb
spec
|___queries
        rotten_potatoes_query_spec.rb
```

so it gives us two files in total:

**file 1:** _app/queries/rotten_potatoes_query.rb_
```
# frozen_string_literal: true

module Queries
  class RottenPotatoesQuery < ApplicationService
    def initialize(relation)
      @relation = relation
    end
  end
end

```

The first file contains `RottenPotatoesQuery` which has single `initialize`
method, with a single `relation` argument assigned to the `@relation` instance
variable.

As you have probably noticed, `QueryObjects` are placed in `Queries` module,
just like `ServiceObjects` are placed in the `Services` module. I like to keep
those that way (hence _opinionated_), but thankfully Rails is smart enought to
find their invocation without `Queries::` prefix, so you can use both:

```
Queries::RottenPotatoesQuery.new
# and
RottenPotatoesQuery.new
```

**file 2:** _spec/services/potato_peel_service_spec.rb_
```
# frozen_string_literal: true

RSpec.describe Queries::RottenPotatoesQuery do
  pending 'add some examples to (or delete) spec/queries/rotten_potatoes_query_spec.rb'
end

```

The second file contains an empty struture to test our brand new `RottenPotatoesQuery`.

### Generating methods

The gem allows us to predefine methods for our `QueryObjects`, same as for `ServiceObjects`.

```
rails generate query rotten_potatoes public:find protected:empty_bag private:out_of_date
```

results in:

**file 1:** _app/queries/rotten_potatoes_query.rb_
```
# frozen_string_literal: true

module Queries
  class RottenPotatoesQuery
    def initialize(relation)
      @relation = relation
    end

    def find
    end

    protected

    def empty_bag
    end

    private

    def out_of_date
    end
  end
end

```

which is the same file structure as before with additional class methods scoped
accordingly.

**file 2:** _spec/services/potato_peel_service_spec.rb_
```
# frozen_string_literal: true

RSpec.describe Queries::RottenPotatoesQuery do
  describe '#find' do
    pending 'add some examples to (or delete) spec/queries/rotten_potatoes_query_spec.rb#find'
  end
end

```

and the `_spec.rb` file a `describe` block for the `public` method passed.

### Submodules

It is possible to generate query objects with additional namespaces - generator
syntax is the same as with Rails controllers or `ServiceObjects`:

```
$ rails generate query rotten_vegetables/potatoes
```

or even deeper, spearating your modules with backslashes `/`.

The command call above results in the following:


```
app
|___queries
|   |___rotten_vegetables
|           potatoes_query.rb
spec
|___rotten_vegetables
        potatoes_query_spec.rb  
```

**file 1:** _app/queries/rotten_vegetables/potatoes_query.rb_
```
# frozen_string_literal: true

module Queries
  module RottenVegetables
    class PotatoesQuery
      def initialize(relation)
        @relation = relation
      end
    end
  end
end

```

**file 2:** _spec/queries/rotten_vegetables/potatoes_query_spec.rb_
```
# frozen_string_literal: true

RSpec.describe Queries::RottenVegetables::PotatoesQuery do
  pending 'add some examples to (or delete) spec/queries/rotten_vegetables/potatoes_query_spec.rb'
end

```

And you can pass them `public`, `protected` and `private` methods too, as
described in Generating methods section:

```
$ rails generate query rotten_vegetables/potatoes public:find
```

results in:

**file 1:** _app/services/peelers/potato_service.rb_
```
# frozen_string_literal: true

module Queries
  module RottenVegetables
    class PotatoesQuery
      def initialize(relation)
        @relation = relation
      end

      def find
      end
    end
  end
end

```

and corresponding:

**file 2:** _spec/services/peelers/potato_service_spec.rb_
```
# frozen_string_literal: true

RSpec.describe Queries::RottenVegetables::PotatoesQuery do
  describe '#find' do
    pending 'add some examples to (or delete) spec/queries/rotten_vegetables/potatoes_query_spec.rb#find'
  end
end

```

# Advanced usage - creating your own generators

As you've probably noticed, `ServiceObject` generator and `QueryObject`
generator are very similar. They both inherit from the
`NestedGeneratorsBaseGenerator` class, which includes bunch of helpful methods
to write your own generator, with support for nesting and passing method names
via CLI.

## Step by step guide

In this short guide, we will create our own `ValueObject` generator:

#### Step 1

In your `lib` directory, create `generators/value/templates` subdirectories:

```
mkdir -p lib/generators/value/templates
```

#### Step 2

Create our `value_generator.rb`, next to `templates` directory:

```
touch lib/generators/value/value_generator.rb
```

#### Step 3

In the `lib/generators/value/templates` directory, create two templates, one
for the `ValueObject` class and second for its tests

```
touch lib/generators/templates/class_template.erb
touch lib/generators/templates/class_spec_template.erb
```

#### Step 4

Start with editing `value_generator.rb` file; open it in your text editor and
paste the following code:

```
# frozen_string_literal: true

require 'generators/nested_generators_base_generator'

class ValueGenerator < NestedGeneratorsBaseGenerator
  source_root File.expand_path('templates', __dir__)

  def initialize(*args, &block)
    super
    @type = 'value'
  end

  def create_value_file
    create_class_file
    create_class_spec_file
  end
end

```

#### Step 5

Next, open the `templates/class_template.erb` and paste the following code:

```
# frozen_string_literal: true

<%= open_modules_nesting %><%= open_class %>
<%= code_indent %>include Comparable

<%= code_indent %>def initialize
<%= code_indent %>end

<%- SCOPES.each.with_index do |name, index| -%>
  <%- if index.zero? -%>
    <%- if scope?(name) -%>
      <%- scope_methods(name).each do |method| %>
<%= code_indent %>def <%= method.gsub("#{name}:", '') %>
<%= code_indent %>end
      <%- end -%>
    <%- end -%>
  <%- else -%>
    <%- if scope?(name) -%><%- %>
<%- %><%= code_indent %><%= name %>
      <%- scope_methods(name).each do |method| %>
<%= code_indent %>def <%= method.gsub("#{name}:", '') %>
<%= code_indent %>end
      <%- end -%>
    <%- end -%>
  <%- end -%>
<%- end -%>
<%= end_class %><%= close_modules_nesting %>

```

#### Step 6

And at last, edit the `templates/class_spec_template.erb` with:

```
# frozen_string_literal: true

RSpec.describe <%= @type.capitalize.pluralize %>::<%= class_name %><%= @type.capitalize %> do
  <%- if scope?('public') -%>
    <%- scope_methods('public').each do |method| -%>
  describe '#<%= strip_scope(method, 'public') %>' do
    <%= rspec_empty_message(strip_scope(method, 'public')) %>
  end
    
    <%- end -%>
  <%- else -%>
  <%= rspec_empty_message %>
  <%- end -%>
end

```

#### Step 7 - Use it!

Your done, congrats. Now, you can use:

```
rails generate value rating 'public:better_than?' 'public:<=>' public:hash 'public:eql?' public:to_s
```

resulting in

**file 1:** _app/values/rating_value.rb_
```
# frozen_string_literal: true

module Values
  class RatingValue
    include Comparable

    def initialize
    end

    def better_than?
    end

    def <=>
    end

    def hash
    end

    def eql?
    end

    def to_s
    end
  end
end
```

and

**file 2:** _spec/values/rating_value_spec.rb_
```
# frozen_string_literal: true

RSpec.describe Values::RatingValue do
  describe '#better_than?' do
    pending 'add some examples to (or delete) spec/values/rating_value_spec.rb#better_than?'
  end

  describe '#<=>' do
    pending 'add some examples to (or delete) spec/values/rating_value_spec.rb#<=>'
  end

  describe '#hash' do
    pending 'add some examples to (or delete) spec/values/rating_value_spec.rb#hash'
  end

  describe '#eql?' do
    pending 'add some examples to (or delete) spec/values/rating_value_spec.rb#eql?'
  end

  describe '#to_s' do
    pending 'add some examples to (or delete) spec/values/rating_value_spec.rb#to_s'
  end
end

```

And the nested version, like `ServiceObject` and `QueryObject` do.

# License

[The MIT License](LICENSE.md)

[sidekiq]: https://github.com/mperham/sidekiq
[codeclimate article]: https://codeclimate.com/blog/7-ways-to-decompose-fat-activerecord-models/

[Gem Version]: https://rubygems.org/gems/nested-generators
[Build Status]: https://circleci.com/gh/wscourge/nested-generators/tree/master
[Coverage Status]: https://coveralls.io/r/wscourge/nested-generators

[GV img]: https://badge.fury.io/rb/nested-generators.svg
[BS img]: https://circleci.com/gh/wscourge/nested-generators/tree/master.svg?style=shield
[CS img]: https://coveralls.io/repos/wscourge/nested-generators/badge.svg?branch=master
