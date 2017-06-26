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

require 'poise/helpers/defined_in'


module PoiseDSL
  # Core DSL helpers for poise-dsl.
  #
  # @since 1.0.0
  module DSL
    extend self

    # Create a DSL helper method and set it up to be used by recipe code.
    #
    # @param name [String, Array<String>] Cookbook name or names to enable the
    #   DSL for. If not specified, defaults to the cookbook the DSL was defined
    #   in.
    # @param global [Boolean] If enabled, enable the DSL for all cookbooks.
    # @param block [Proc] Module definition body.
    # @return [void]
    # @example
    #   PoiseDSL::DSL.declare_dsl do
    #     def helper_method
    #       # ..
    #     end
    #   end
    def declare_dsl(name=nil, global: false, &block)
      raise ArgumentError.new('No block given for DSL creation') unless block
      raise ArgumentError.new('Cannot specify both a cookbook name and global mode') if name && global

      # Create the mixin module.
      dsl_mod = Module.new(&block)

      # Handle the simple case for global DSL modifications. Probably don't use
      # this feature much.
      if global
        Chef::Recipe.include(dsl_mod)
        Chef::Resource.include(dsl_mod)
        # TODO: Provider?
        return
      end

      # Find which cookbook we were declared in.
      unless name
        name_mod = Module.new do
          def self.name
            'poise-dsl stub'
          end
          extend Poise::Helpers::DefinedIn::ClassMethods
        end
        name_mod.poise_defined!(caller)
      end

      # Activator module used as part of the monkeypatching.
      do_patch = lambda do |obj|
        # Find the actual cookbook name the DSL was defined in if no explicit
        # name request was given.
        name ||= name_mod.poise_defined_in_cookbook(obj.run_context)
        # Check if we should enable this DSL.
        if Array(name).include?(obj.cookbook_name)
          obj.singleton_class.prepend(dsl_mod)
        end
      end

      # Patch the loading behavior in to Chef::Recipe.
      Chef::Recipe.prepend(Module.new do
        define_method(:initialize) do |*args, &init_block|
          super(*args, &init_block)
          do_patch.call(self)
        end
      end)

      # Patch the loading behavior in to Chef::Resource.
      Chef::Resource.prepend(Module.new do
        define_method(:resource_initializing=) do |val|
          do_patch.call(self) if val
          super(val)
        end
      end)
    end

  end
end
