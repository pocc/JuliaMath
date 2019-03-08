# Base example for PackageCompiler

module Hello
  function hello_world()
    return "Hello World!"
  end
  
  not_importing_module = PROGRAM_FILE != "arithmetic.jl"
  if not_importing_module 
    println(hello_world())
  end
end
