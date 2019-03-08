#!/usr/bin/env julia
# -*- coding: utf-8 -*-
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
Evaluate a derivative of a single-variable function
Assume last argument is value/var and all others are function

Usage: 
  $ derive 'x^3 + cos(x) + 1' x
    3 * 1 * x ^ (3 - 1) + 1 * -(sin(x)) 

  $ derive 'x^3 + cos(x) + 1' 5
    75.95892427466313
=#

module CliDerive
  import Calculus
  function derive(ARGS)
    is_symbolic_derivative = (match(r"\d+", ARGS[end]) === nothing)
    if is_symbolic_derivative
      polynomial = join(ARGS[1:end-1])  
      return Calculus.differentiate(polynomial, ARGS[end])
    else
      # Passed in string is evalled, but MUST be differentiable
      # Random strings get converted to 0
      # So this is unlikely to be a security risk
      poly_str = replace(ARGS[1], r"[A-Za-z]" => "x") 
      x = parse(Float64, ARGS[end])
      derived_fn = Calculus.differentiate(poly_str, "x")
      derived_str = replace(string(derived_fn), r"x" => "$x")
      return eval(Meta.parse(derived_str))
    end
  end

  not_importing_module = (PROGRAM_FILE != "derive.jl") 
  not_using_cli = (ARGS[1] != "derive.jl")
  if not_importing_module || not_using_cli
    println(derive(ARGS))
  end 
end

