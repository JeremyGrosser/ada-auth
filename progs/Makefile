GNATMAKE ?= gnatmake
GNATCLEAN ?= gnatclean

GNATFLAGS := ${GNATFLAGS} -gnata

TARGETS := arm_formatter rtf2form

all:
	$(GNATMAKE) ${GNATFLAGS} ${TARGETS}

clean:
	$(GNATCLEAN) ${TARGETS}
