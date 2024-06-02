CXX = g++
CXXFLAGS += -std=c++17 -O2 -g -Wall
INCLUDES += -I./tomlplusplus/include/

SOURCES=ffcpp.cpp libreadtoml.cpp 

all: ffgo ffrust ffcpp

ffgo:
	go build ffgo.go

ffrust:
	rustc ffrust.rs

ffcpp:
	$(CXX) $(CXXFLAGS) $(SOURCES) $(INCLUDES)