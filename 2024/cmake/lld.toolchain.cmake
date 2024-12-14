set(CMAKE_EXE_LINKER_FLAGS_INIT
    "-fuse-ld=lld -L/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib/ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"
)
set(CMAKE_MODULE_LINKER_FLAGS_INIT "-fuse-ld=lld")
set(CMAKE_SHARED_LINKER_FLAGS_INIT "-fuse-ld=lld")
