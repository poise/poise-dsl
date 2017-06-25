# Poise-Dsl Cookbook

[![Build Status](https://img.shields.io/travis/poise/poise-dsl.svg)](https://travis-ci.org/poise/poise-dsl)
[![Gem Version](https://img.shields.io/gem/v/poise-dsl.svg)](https://rubygems.org/gems/poise-dsl)
[![Cookbook Version](https://img.shields.io/cookbook/v/poise-dsl.svg)](https://supermarket.chef.io/cookbooks/poise-dsl)
[![Coverage](https://img.shields.io/codecov/c/github/poise/poise-dsl.svg)](https://codecov.io/github/poise/poise-dsl)
[![Gemnasium](https://img.shields.io/gemnasium/poise/poise-dsl.svg)](https://gemnasium.com/poise/poise-dsl)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

A [Chef](https://www.chef.io/) cookbook for declaring DSL helper methods.

## Quick Start

```ruby
# libraries/default.rb
PoiseDSL do
  def my_helper_method
    node['some_value'] + 'foo'
  end
end

# recipes/default.rb
file '/something' do
  content my_helper_method
end
```

## Defining Helper Methods

Use the `PoiseDSL` method to define a set of helper methods. By default, the
helpers will be made available to all recipes in the cookbook you define them
in. You can also pass a cookbook name or array of cookbook names (`PoiseDSL('mycookbook')`)
to make the helper methods available to the specified cookbooks. You can also
use `PoiseDSL(global: true)` to make the helper methods everywhere.

At this time the helper methods are not made available in all custom resource
contexts, though this may be added in the future.

## Sponsors

Development sponsored by [SAP](https://www.sap.com/).

The Poise test server infrastructure is sponsored by [Rackspace](https://rackspace.com/).

## License

Copyright 2017, Noah Kantrowitz

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
