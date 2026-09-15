RGBASM ?= rgbasm
RGBLINK ?= rgblink
PYTHON ?= python3

BUILD_DIR := build
AKA_ROM := baseroms/pocket_monsters_aka_japan.gb
AKA_REV_A_ROM := baseroms/pocket_monsters_aka_japan_rev_a.gb

.PHONY: all clean verify verify-inputs

all: $(BUILD_DIR)/pocket_monsters_aka_japan.gb $(BUILD_DIR)/pocket_monsters_aka_japan_rev_a.gb

$(BUILD_DIR):
	mkdir -p $@

$(BUILD_DIR)/aka.o: src/aka.asm src/banks.inc $(AKA_ROM) | $(BUILD_DIR)
	$(RGBASM) -o $@ $<

$(BUILD_DIR)/aka_rev_a.o: src/aka_rev_a.asm src/banks.inc $(AKA_REV_A_ROM) | $(BUILD_DIR)
	$(RGBASM) -o $@ $<

$(BUILD_DIR)/pocket_monsters_aka_japan.gb: $(BUILD_DIR)/aka.o
	$(RGBLINK) -o $@ $<

$(BUILD_DIR)/pocket_monsters_aka_japan_rev_a.gb: $(BUILD_DIR)/aka_rev_a.o
	$(RGBLINK) -o $@ $<

verify-inputs:
	$(PYTHON) tools/verify_rom.py aka $(AKA_ROM)
	$(PYTHON) tools/verify_rom.py aka-rev-a $(AKA_REV_A_ROM)

verify: all
	$(PYTHON) tools/verify_rom.py aka $(BUILD_DIR)/pocket_monsters_aka_japan.gb
	$(PYTHON) tools/verify_rom.py aka-rev-a $(BUILD_DIR)/pocket_monsters_aka_japan_rev_a.gb

clean:
	rm -rf $(BUILD_DIR)

