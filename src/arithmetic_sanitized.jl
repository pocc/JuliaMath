# Copyright 2019 Ross Jacobs All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Basic arithmetic (+/-/*/÷) Polish calculator that sanitizes input

module AritmeticSanitized
  function sane_calc()
    subtract(args) = args[1] - sum(args[2:end])
    divide(args) = args[1] / prod(args[2:end])
   
    if size(ARGS, 1) < 3
      ArgumentError("You must enter an operation(+/-/*/÷) and 2 numbers")
    end
    op = ARGS[1]
    numbers = []
    
    try
      numbers = map(arg->parse(Int64, arg), ARGS[2:end])
    catch
      ArgumentError("ERROR! Other args must be numbers")
    end

    basic_operations = Dict(
      "+" => sum,
      "-" => subtract,
      "*" => prod,
      "/" => divide,
      "÷" => divide
      ) 
    if op in keys(basic_operations)
      return basic_operations[op](numbers) 
    else
      ArgumentError("ERROR! First arg must be one of [ + - * / ÷ ]")
    end
  end
end   

