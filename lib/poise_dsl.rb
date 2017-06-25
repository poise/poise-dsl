#
# Copyright 2017, Noah Kantrowitz
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


# Top-level module for poise-dsl.
#
# @since 1.0.0
module PoiseDSL
  autoload :DSL, 'poise_dsl/dsl'
  autoload :VERSION, 'poise_dsl/version'
end

# Can also be used as a method for a shorter syntax when defining a DSL.
#
# @example
#   PoiseDSL do
#     def helper_method
#       # ..
#     end
#   end
def PoiseDSL(*args, &block)
  PoiseDSL::DSL.declare_dsl(*args, &block)
end
