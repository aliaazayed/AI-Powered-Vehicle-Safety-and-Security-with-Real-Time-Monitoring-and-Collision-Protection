# Project Configuration
PROJECT = uart
MCU = stm32f103
TARGET = $(PROJECT)

# Toolchain Configuration
CC = arm-none-eabi-gcc
CXX = arm-none-eabi-g++
OBJCOPY = arm-none-eabi-objcopy
SIZE = arm-none-eabi-size
OBJDUMP = arm-none-eabi-objdump

# Paths and Includes
BUILD_DIR = build
INC_DIRS = -I. -I./inc
SRC_DIRS = Src

# Compiler Flags
CFLAGS = -Wall -Wextra -std=c99 -g
CFLAGS += -mcpu=cortex-m3 -mthumb
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += $(INC_DIRS)

# Linker Flags
LDFLAGS = -mcpu=cortex-m3 -mthumb
LDFLAGS += -nostartfiles
LDFLAGS += -Wl,--gc-sections
LDFLAGS += -T$(BUILD_DIR)/$(MCU).ld

# Source Files (including files from subdirectories)
SOURCES = $(wildcard $(SRC_DIRS)/*.c) $(wildcard *.c)
STARTUP_FILE = $(SRC_DIRS)/stm32f103_startup.c
SOURCES += $(STARTUP_FILE)

# Object Files
OBJS = $(SOURCES:.c=.o)

# Build Targets
.PHONY: all clean flash size disasm

all: $(TARGET).elf $(TARGET).hex size

# Compile source files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Link
$(TARGET).elf: $(OBJS)
	$(CC) $(LDFLAGS) $^ -o $@

# Convert to HEX
$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex $< $@

# Display size
size: $(TARGET).elf
	$(SIZE) $<

# Generate disassembly (optional)
disasm: $(TARGET).elf
	$(OBJDUMP) -D $< > $(TARGET).disasm

# Clean
clean:
	rm -f $(OBJS) $(TARGET).elf $(TARGET).hex $(TARGET).map $(TARGET).disasm

# Flash (modify according to your programmer)
flash: $(TARGET).hex
	openocd -f interface/stlink.cfg -f target/stm32f1x.cfg \
		-c "program $(TARGET).hex verify reset exit"
