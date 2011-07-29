CC := gcc
CPU_ARCHITECTURE := pentium-m
BINNAME := gitparse
INPUTFILES := main.c

# Stuff we need
INCLUDECFLAGS := #`pkg-config --cflags sdl`
INCLUDELIBFLAGS := -I"." # -lm `pkg-config --libs sdl`
INCLUDEFLAGS := $(INCLUDECFLAGS) $(INCLUDELIBFLAGS)

# Flags in common by all
CFLAGS := -std=c99 -Wall -W -Wextra -pedantic -pedantic-errors -Wfloat-equal -Wundef -Wshadow -Winit-self -Winline \
-Wpointer-arith -Wcast-align -Wstrict-prototypes -Wmissing-prototypes -Wwrite-strings -Wcast-qual \
-Wswitch-enum -Wconversion -Wformat=2 -Wold-style-definition -Wunreachable-code -Wswitch-default -Wstrict-overflow

# Flags for debugging builds
CDFLAGS := $(CFLAGS) -g -O2 -fstack-protector-all -Wstack-protector -Wstrict-overflow=4
# Flags for normal builds
CNFLAGS := $(CFLAGS) -mtune=$(CPU_ARCHITECTURE) -O3 -fno-stack-protector
# Flags for very aggressive builds
COFLAGS := $(CFLAGS) -mtune=$(CPU_ARCHITECTURE) -O3 -ffast-math -funsafe-loop-optimizations -Wunsafe-loop-optimizations \
-fstrict-aliasing -Wstrict-aliasing -fstrict-overflow

SSEFLAGS := -msse2 -mfpmath=sse

# This stuff is kinda extreme...
EXTREMEFLAGS := -funsafe-math-optimizations -ffinite-math-only -funroll-all-loops

# Profiling stuff:
# -fbranch-probabilities (look more into that kind of stuff) -fpeel-loops -fprofile-use

# Other interesting stuff to look into:
# -floop-block -floop-interchange -floop-strip-mine -fprefetch-loop-arrays


all: clang
default: clean analyze
	@$(CC) $(CNFLAGS) $(INCLUDEFLAGS) $(INPUTFILES) -o $(BINNAME)
default-sse: clean analyze
	@$(CC) $(SSEFLAGS) $(CNFLAGS) $(INCLUDEFLAGS) $(INPUTFILES) -o $(BINNAME)
debug: clean analyze
	@$(CC) $(CDFLAGS) $(INCLUDEFLAGS) $(INPUTFILES) -o $(BINNAME)
optimized: clean analyze
	@$(CC) $(COFLAGS) $(INCLUDEFLAGS) $(INPUTFILES) -o $(BINNAME)
optimized-sse: clean analyze
	@$(CC) $(SSEFLAGS) $(COFLAGS) $(INCLUDEFLAGS) $(INPUTFILES) -o $(BINNAME)
extremely-optimized: clean analyze
	@$(CC) $(COFLAGS) $(EXTREMEFLAGS) $(INCLUDEFLAGS) $(INPUTFILES) -o $(BINNAME)
run:
	@time ./$(BINNAME)
clean:
	@$(RM) $(BINNAME)
	@$(RM) *.plist
install:
	sudo mv $(BINNAME) /usr/bin/


## EXPERIMENTAL CLANG STUFF ##
CLANG := clang
CLANGFLAGS := -std=c99 -march=$(CPU_ARCHITECTURE) -O2
clang: clean analyze
	@$(CLANG) $(CLANGFLAGS) $(INCLUDEFLAGS) $(INPUTFILES) -o $(BINNAME)
analyze:
	@$(CLANG) $(INCLUDECFLAGS) --analyze $(INPUTFILES)

# check-syntax target for flymake.
check-syntax:
	$(CC) $(COFLAGS) $(INCLUDEFLAGS) $(INPUTFILES) -S -o /dev/null
