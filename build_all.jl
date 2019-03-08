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

# Compile all .jl files in src/
# Usage `julia build_all.jl`

module BuildAll
  using Pkg
  if !in("PackageCompiler", keys(Pkg.installed()))
    Pkg.add("PackageCompiler")
  end
  using PackageCompiler
  export build_all

  function make_compile_ready(file_name)
    # Encapsulate the interior of a module with a compile function
    # This is required for a function to compile, but also ensures
    # that the file can be used like `julia file.jl ARGS`
    # File MUST contain EXACTLY ONE module
    if !isdir("builddir")
      mkdir("builddir")
    end 
    rel_file_name = string("src/", file_name)
    file_text = read(rel_file_name, String)
    file_regex = r"(module .*?\n[\s]*(?:(?:import|using|include).*?\n)*)" 
    file_text = replace(file_text, file_regex
	  => s"\1
      Base.@ccallable function julia_main(ARGS::Vector{String})::Cint
      ")
    file_text = replace(file_text, r"(\nend[\s]*)$"  => s"
    return 0
    end\1")
    temp_file_name = string("builddir/temp_", file_name)
    write(temp_file_name, file_text)
    println("Generated temp file")
    return temp_file_name 
  end
  
  function build_all()
    for file in filter(x -> endswith(x, ".jl"), readdir("src"))
      println("Building ", file[1:end-3], "...\n")  
      #build_shared_lib(string("src/", file), file[1:end-3])
      compile_ready_file = make_compile_ready(file)
      build_executable(compile_ready_file, file[1:end-3])
    end
  end
  
  not_importing_module = (PROGRAM_FILE != "build_all.jl")
  not_using_cli = (ARGS[1] != "build.jl")
  if not_importing_module || not_using_cli
    build_all()
  end 
end
