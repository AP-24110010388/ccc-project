# =============================================================================
# Makefile — fallback build for Multi-Constraint Project Selection System
# =============================================================================
# Usage:
#   make            build both mcps and mcps_tests
#   make run        build and launch the interactive app
#   make test       build and run all unit tests
#   make clean      remove build artefacts
# =============================================================================

CXX      := g++
CXXFLAGS := -std=c++17 -O2 -Wall -Wextra -Wpedantic
SRCDIR   := src
TESTDIR  := tests

# Source files (shared between app and tests)
CORE_SRCS := $(SRCDIR)/Project.cpp $(SRCDIR)/Planner.cpp

# Targets
APP       := mcps
TESTS     := mcps_tests

.PHONY: all run test clean

all: $(APP) $(TESTS)

# ── Main application ──────────────────────────────────────────────────────────
$(APP): $(SRCDIR)/main.cpp $(CORE_SRCS)
	$(CXX) $(CXXFLAGS) $^ -o $@
	@echo "  Built: ./$(APP)"

# ── Test binary ───────────────────────────────────────────────────────────────
$(TESTS): $(TESTDIR)/test_main.cpp $(CORE_SRCS)
	$(CXX) $(CXXFLAGS) $^ -o $@
	@echo "  Built: ./$(TESTS)"

# ── Convenience targets ───────────────────────────────────────────────────────
run: $(APP)
	./$(APP)

test: $(TESTS)
	@echo ""
	./$(TESTS)
	@echo ""

# ── Clean ─────────────────────────────────────────────────────────────────────
clean:
	rm -f $(APP) $(TESTS) *.o
	@echo "  Cleaned."
