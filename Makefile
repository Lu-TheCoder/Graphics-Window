BUILD_DIR:= bin
OBJ_DIR:= obj

DEFINES: -std=c2x -DGEXPORT

COMPILER_FLAGS:= -Wall -Werror -Wvla -Wgnu-folding-constant -Wno-missing-braces -ObjC
INCLUDE_FLAGS:= -Isrc
LINKER_FLAGS:= -lobjc -framework AppKit -framework QuartzCore -framework Cocoa -framework Foundation
SRC_FILES:= $(shell find src -type f \( -name "*.c" -o -name "*.m" \))
DIRECTORIES:= $(shell find src -type d)
OBJ_FILES := $(SRC_FILES:%=$(OBJ_DIR)/%.o)

all: scaffold compile link run

.PHONY: scaffold
scaffold:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(addprefix $(OBJ_DIR)/,$(DIRECTORIES))

.PHONY: link
link: scaffold $(OBJ_FILES) # link
	@echo --- Linking "Engine" ---
	@clang $(OBJ_FILES) -o $(BUILD_DIR)/app $(LINKER_FLAGS)
	@echo --- Done ---

.PHONY: compile
compile:
	@echo --- Performing "Engine" MacOS build ---
-include $(OBJ_FILES:.o=.d)


# compile .c to .o object for windows, linux and mac
$(OBJ_DIR)/%.c.o: %.c 
	@echo   $<...
	@clang $< $(COMPILER_FLAGS) -c -o $@ $(DEFINES) $(INCLUDE_FLAGS)

# compile .m to .o object only for macos
$(OBJ_DIR)/%.m.o: %.m
	@echo   $<...
	@clang $< $(COMPILER_FLAGS) -c -o $@ $(DEFINES) $(INCLUDE_FLAGS)

-include $(OBJ_FILES:.o=.d)

.PHONY: run 
run:
	@echo --- Launching "Engine" --- 
	./bin/app