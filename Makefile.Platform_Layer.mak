BUILD_DIR:= bin
OBJ_DIR:= obj

DEFINES: -DGEXPORT

COMPILER_FLAGS:= -std=c2x -Wall -Werror -Wvla -Wgnu-folding-constant -Wno-missing-braces -ObjC
INCLUDE_FLAGS:= -I./$(ASSEMBLY)
LINKER_FLAGS:= -lobjc -framework AppKit -framework QuartzCore -framework Cocoa -framework Foundation -framework Metal
SRC_FILES:= $(shell find $(ASSEMBLY) -type f \( -name "*.c" -o -name "*.m" \))
DIRECTORIES:= $(shell find $(ASSEMBLY) -type d)
OBJ_FILES := $(SRC_FILES:%=$(OBJ_DIR)/%.o)

ifeq ($(TARGET), release)
# release
DEFINES += -D_RELEASE
COMPILER_FLAGS += -MD -O3
else
# debug
DEFINES += -D_DEBUG
COMPILER_FLAGS += -g -MD -O0
endif

all: scaffold compileShaders compile link run

.PHONY: scaffold
scaffold:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(addprefix $(OBJ_DIR)/,$(DIRECTORIES))

.PHONY: link
link: scaffold $(OBJ_FILES) # link
	@echo --- Linking "Engine" ---
	@gcc $(OBJ_FILES) -o $(BUILD_DIR)/app $(LINKER_FLAGS)
	@echo --- Done ---

.PHONY: compile
compile:
	@echo --- Performing "Engine" MacOS build ---
-include $(OBJ_FILES:.o=.d)


# compile .c to .o object for windows, linux and mac
$(OBJ_DIR)/%.c.o: %.c 
	@echo   $<...
	@gcc $< $(COMPILER_FLAGS) -c -o $@ $(DEFINES) $(INCLUDE_FLAGS)

# compile .m to .o object only for macos
$(OBJ_DIR)/%.m.o: %.m
	@echo   $<...
	@gcc $< $(COMPILER_FLAGS) -c -o $@ $(DEFINES) $(INCLUDE_FLAGS)

-include $(OBJ_FILES:.o=.d)

.PHONY: run 
run:
	@echo --- Launching "Engine" --- 
	./bin/app

.PHONY: compileShaders
compileShaders:
	@echo --- Compiling Metal Shaders ---
	@xcrun -sdk macosx metal -c src/shaders/shaders.metal -o bin/shaders.air
	@xcrun -sdk macosx metallib bin/shaders.air -o bin/shaders.metallib

#run this if u have issues compiling metal shaders
#sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
