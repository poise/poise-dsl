#
# Copyright 2017, Noah Kantrowitz
#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe PoiseDSL::DSL do
  # Declare some DSLs to work with for testing. Since these can't be cleaned up
  # there is no good way to isolate the tests right now.
  described_class.declare_dsl('poise-dsl_spec') do
    def helper_method_one
      'one'
    end
  end

  described_class.declare_dsl('poise-dsl_other') do
    def helper_method_two
      'two'
    end
  end

  described_class.declare_dsl(%w{poise-dsl_spec other}) do
    def helper_method_three
      'three'
    end

    def helper_method_four
      'four'
    end
  end

  described_class.declare_dsl(global: true) do
    def helper_method_five
      'five'
    end
  end

  described_class.declare_dsl do
    def helper_method_six
      'six'
    end
  end

  PoiseDSL do
    def helper_method_seven
      'seven'
    end
  end

  context 'with a recipe-level helper' do
    recipe do
      val = helper_method_one
      file '/test' do
        content val
      end
    end

    it { is_expected.to create_file('/test').with(content: 'one') }
  end # /context with a recipe-level helper

  context 'with a resource-level helper' do
    recipe do
      file '/test' do
        content helper_method_one
      end
    end

    it { is_expected.to create_file('/test').with(content: 'one') }
  end # /context with a resource-level helper

  context 'with a helper declared for a different cookbook' do
    recipe do
      helper_method_two
    end

    it { expect { subject }.to raise_error NameError }
  end # /context with a helper declared for a different cookbook

  context 'with a helper defined using an array' do
    recipe do
      file '/test' do
        content helper_method_three + helper_method_four
      end
    end

    it { is_expected.to create_file('/test').with(content: 'threefour') }
  end # /context with a helper defined using an array

  context 'with a global helper' do
    recipe do
      file '/test' do
        content helper_method_five
      end
    end

    it { is_expected.to create_file('/test').with(content: 'five') }
  end # /context with a global helper

  context 'with an auto-named helper' do
    recipe do
      self.cookbook_name = 'poise-dsl'
      file '/test' do
        content helper_method_six
      end
    end

    it { is_expected.to create_file('/test').with(content: 'six') }
  end # /context with an auto-named helper

  context 'with the short definition syntax' do
    recipe do
      self.cookbook_name = 'poise-dsl'
      file '/test' do
        content helper_method_seven
      end
    end

    it { is_expected.to create_file('/test').with(content: 'seven') }
  end # /context with the short definition syntax
end






