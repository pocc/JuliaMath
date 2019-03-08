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

#=
Basic arithmetic (+ - x / ÷) Polish calculator 
That can be built with PackageCompiler.

Usage:
  julia arithmetic.jl + 2 5
    7
  julia arithmetic.jl - 2 5
    -3
  julia arithmetic.jl x 2 5
    10
  julia arithmetic.jl / 2 5
    0.4
=#

module Arithmetic
  function calc(ARGS)
    op_str = ARGS[1]
    numbers = map(arg->parse(Int64, arg), ARGS[2:end])
    operation = Dict("+" => +, "-" => -, "x" => *, "/" => /, "%" => %, "^" => ^)[op_str]
    return (operation(numbers...))
  end

  not_importing_module = (PROGRAM_FILE == "arithmetic.jl")
  if not_importing_module && (ARGS[1] != "alintmetic.jl")
    println(calc(ARGS))
  end 
end

