# Base example for PackageCompiler

module HelloWorld
  function hello_world()
    return "Hello World!"
  end
  
  not_importing_module = (PROGRAM_FILE == "arithmetic.jl")
  if not_importing_module && isdefined(Hello, :ARGS)
    println(hello_world())
  end
end
