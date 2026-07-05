.PHONY: help doctor demo-help example-help demo example example-config chmod

SCRIPT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ROOT_DIR := $(abspath $(SCRIPT_DIR)/../..)

RECORD        ?= $(SCRIPT_DIR)/record.sh
RECORD_DEMO   ?= $(SCRIPT_DIR)/record-demo.sh
RECORD_EXAMPLE?= $(SCRIPT_DIR)/record-example.sh

DIR ?= $(ROOT_DIR)
CMD ?=
NN  ?= 01

help:
	@echo "Recording tools"
	@echo "  make -C scripts/recording help"
	@echo
	@echo "Targets:"
	@echo "  help            show this help"
	@echo "  doctor          print resolved config for record.sh"
	@echo "  demo-help       show record-demo.sh usage"
	@echo "  example-help    show record-example.sh usage"
	@echo "  demo            run record-demo.sh with DIR=<path> CMD='<command>'"
	@echo "  example         run record-example.sh with NN=<id>"
	@echo "  chmod           ensure scripts are executable"
	@echo
	@echo "Variables:"
	@echo "  DIR             target directory for demo recordings"
	@echo "  CMD             preloaded command for demo recordings"
	@echo "  NN              example id for record-example.sh"
	@echo
	@echo "Examples:"
	@echo "  make -C scripts/recording doctor"
	@echo "  make -C scripts/recording demo DIR=. CMD='leather run --pretty tanning/agents/foo.agent.md'"
	@echo "  make -C scripts/recording example NN=09-live"

doctor:
	@"$(RECORD)" --print-config "$(DIR)"

demo-help:
	@"$(RECORD_DEMO)" --help

example-help:
	@"$(RECORD_EXAMPLE)" --help

demo:
	@"$(RECORD_DEMO)" "$(DIR)" $(CMD)

example:
	@"$(RECORD_EXAMPLE)" "$(NN)"

chmod:
	@chmod +x "$(RECORD)" "$(RECORD_DEMO)" "$(RECORD_EXAMPLE)"
