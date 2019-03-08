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

# Integration test for all functions


module TestAll
  using Test
  include("../src/arithmetic.jl")
  include("../src/derive.jl")
  include("../src/hello_world.jl")

  if endswith(pwd(), "test")
    cd("..")
  end
  test_imported_fns()
  # rebuild_binaries_if_stale()
  test_generated_binaries()

  function test_imported_fns()
    @test HelloWorld.hello_world() == "Hello World!"
    @test Arithmetic.calc(["+", "2", "5"]) == 7
    @test Arithmetic.calc(["-", "2", "5"]) == -3
    @test Arithmetic.calc(["x", "2", "5"]) == 10
    @test Arithmetic.calc(["/", "2", "5"]) == 0.4
    @test CliDerive.derive(["x^3 + x*cos(x) + π", "5"]) == 75.459386652653
    @test CliDerive.derive(["x^3 + x*cos(x) + π", "x"]) == 
      :(3 * 1 * x ^ (3 - 1) + (1 * sin(x) + x * (1 * cos(x))))
  end

  function rebuild_binaries_if_stale()
    # Building all requires a couple minutes per target so avoid if possible
    # If builddir does not exist, mtime == 0
    builddir_stale = time() - stat("builddir").mtime > 86400
    if builddir_stale
      include("../build_all.jl")
      @test BuildAll.build_all()
    end
  end

  function test_generated_binaries()
    cd("builddir")
    @test run(`./arithmetic + 2 5`) == 7
    @test run(`./arithmetic - 2 5`) == -3
    @test run(`./arithmetic x 2 5`) == 10
    @test run(`./arithmetic / 2 5`) == 0.4
    @test run(`./derive "x^3 + x*cos(x) + π" 5`) == 75.459386652653
    @test run(`./derive "x^3 + x*cos(x) + π" x`) == 
      :(3 * 1 * x ^ (3 - 1) + (1 * sin(x) + x * (1 * cos(x))))
  end
end
