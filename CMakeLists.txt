cmake_minimum_required(VERSION 3.14)
project(MultiConstraintProjectSelection VERSION 1.0.0 LANGUAGES CXX)

# ── C++ standard ────────────────────────────────────────────────────────────
set(CMAKE_CXX_STANDARD          17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS        OFF)

# ── Compiler warnings ────────────────────────────────────────────────────────
if(MSVC)
    add_compile_options(/W4 /WX)
else()
    add_compile_options(-Wall -Wextra -Wpedantic -Werror)
endif()

# ── Shared library of core logic (reused by main and tests) ─────────────────
add_library(mcps_core STATIC
    src/Project.cpp
    src/Planner.cpp
)
target_include_directories(mcps_core PUBLIC ${CMAKE_SOURCE_DIR}/src)

# ── Main executable ──────────────────────────────────────────────────────────
add_executable(mcps src/main.cpp)
target_link_libraries(mcps PRIVATE mcps_core)

# ── Test executable ──────────────────────────────────────────────────────────
enable_testing()
add_executable(mcps_tests tests/test_main.cpp)
target_link_libraries(mcps_tests PRIVATE mcps_core)

add_test(NAME UnitTests COMMAND mcps_tests)
