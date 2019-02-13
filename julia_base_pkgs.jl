Pkg.add("UUIDs")
Pkg.add("HTTP")
Pkg.add("LinearAlgebra")
Pkg.add("Statistics")
Pkg.add("JuliaDB")
Pkg.add("DataFrames")
Pkg.add("IndexedTables")
Pkg.add("SQLite")
Pkg.add("ZMQ")
Pkg.add("Gumbo")
Pkg.add("Cascadia")
Pkg.add("JSON")
Pkg.add("LightXML")
Pkg.add("CSVFiles")
Pkg.add("CSV")
Pkg.add("FileIO")
Pkg.add("Distributions")
Pkg.add("JuMP")
Pkg.add("Primes")
Pkg.add("Images")
Pkg.add("SHA")
Pkg.add("Electron")
Pkg.add("URIParser")
Pkg.add("ElectronDisplay")
Pkg.add("WebIO")
Pkg.add("Gadfly")
Pkg.add("MacroTools")
Pkg.add("DataVoyager")
Pkg.add("Queryverse")
Pkg.add("VegaDataSets")
Pkg.add("Mustache")
Pkg.add("QuantumOptics")

# Loading module extensions
using LinearAlgebra
using Statistics
using JuliaDB
using SQLite
using DataFrames
using ZMQ
using JSON
using CSVFiles
using FileIO
using JuMP
using Primes
using ModernGL
using GLFW
using Electron
using URIParser
using DataVoyager
using ElectronDisplay
using MacroTools
using WebIO
using Images
Pkg.add("OpenCL", v"0.6.9")

Pkg.clone("https://github.com/essenciary/Genie.jl")
using Genie
Genie.REPL.new_app("your_cool_new_app") # Genie will create a new app
# append this to /your_cool_new_app/config/routes.jl
route("/hello") do
  "Hello - Welcome to Genie!"
end
AppServer.startup()

Pkg.clone("https://github.com/JunoLab/Blink.jl.git")
Pkg.add("Blink")

Pkg.add("ModernGL")
Pkg.add("GLFW")
"UUIDs" in keys(Pkg.installed())

ENV["JUPYTER"]="jupyter"
ENV["is_apple"]=false
ENV["PYTHON"] = "d:/binr/Python35/python.exe"
Pkg.clone("https://github.com/shashi/WebIO.jl.git")
Pkg.build("WebIO")
using WebIO
readdir(dirname(pathof(WebIO)))
readdir(joinpath(dirname(pathof(WebIO)),"../packages/jupyter-notebook-provider"))
cd(joinpath(dirname(pathof(WebIO)),"../packages/"))
;jupyter nbextension install webio
;jupyter nbextension enable webio/jupyterlab_entry
Pkg.add("NodeJS")
using WebIO
WebIO.bundlejs()
node(:div, "Hello, World")

Pkg.add("PyCall")
Pkg.build("PyCall")
Pkg.add("IJulia")
Pkg.build("IJulia")
Pkg.add("Conda")
Pkg.build("Conda")
Pkg.add("PyPlot")
Pkg.build("PyPlot")
Pkg.add("SymPy")
Pkg.build("SymPy")

using PyCall
@pyimport scipy.optimize as so
using IJulia
using Conda
using PyPlot
using SymPy

using HTTP
HTTP.get("http://estudiolaboratorio2.herokuapp.com/version")

using IJulia
notebook(dir="c:/users/logicaudio/desktop/Store2/notebook", detached=true)