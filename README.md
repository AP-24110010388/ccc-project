# Multi-Constraint Project Selection System

A C++17 command-line application that selects the **optimal subset of projects** maximising total profit under two simultaneous resource constraints — **budget** and **time** — using a classic **2-D 0/1 Knapsack Dynamic Programming** algorithm.

---

## Table of Contents

1. [Problem Statement](#problem-statement)  
2. [Features](#features)  
3. [Project Structure](#project-structure)  
4. [Build Instructions](#build-instructions)  
5. [Usage](#usage)  
6. [Algorithm Deep-Dive](#algorithm-deep-dive)  
7. [Complexity Analysis](#complexity-analysis)  
8. [Running Tests](#running-tests)  
9. [Example Output](#example-output)  
10. [Contributing](#contributing)  
11. [License](#license)  

---

## Problem Statement

Given a portfolio of candidate projects, each described by:

| Attribute | Description |
|-----------|-------------|
| `cost`    | Budget units consumed if the project is executed |
| `time`    | Time units consumed if the project is executed |
| `profit`  | Value / impact score gained if the project is executed |

…and two global caps:

- **Max Budget** — the total budget units available  
- **Max Time** — the total time units available  

**Goal:** Choose a subset of projects such that the sum of their profits is maximised, while keeping total cost ≤ Max Budget **and** total time ≤ Max Time.

This is the **2-D 0/1 Knapsack** problem — NP-hard in general, but solvable in pseudo-polynomial time via Dynamic Programming.

---

## Features

| Feature | Details |
|---------|---------|
| **Project management** | Add, remove (by index or name), list, clear |
| **2-D DP solver** | Exact optimal solution via `dp[b][t]` table |
| **Brute-force solver** | Exhaustive enumeration for validation (n ≤ 25) |
| **Result comparison** | Side-by-side DP vs brute-force profit & timing |
| **Resource breakdown** | Shows budget and time utilisation percentages |
| **Interactive CLI** | Menu-driven REPL with immediate demo scenario |
| **Full test suite** | 15 unit tests covering edge cases and correctness |
| **CMake build** | Clean out-of-source build; tested on GCC, Clang, MSVC |

---

## Project Structure

```
multi-constraint-project-selection/
├── CMakeLists.txt          # CMake build definition
├── Makefile                # Simple fallback (no CMake needed)
├── README.md               # This file
├── .gitignore
│
├── src/
│   ├── Project.h           # Project data model
│   ├── Project.cpp
│   ├── Planner.h           # DP engine + project registry
│   ├── Planner.cpp
│   └── main.cpp            # Interactive CLI entry point
│
├── tests/
│   └── test_main.cpp       # 15 self-contained unit tests
│
└── docs/
    └── DESIGN.md           # Full algorithm documentation
```

---

## Build Instructions

### Option A — CMake (recommended)

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/multi-constraint-project-selection.git
cd multi-constraint-project-selection

# Configure and build
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .

# Run the application
./mcps

# Run the tests
ctest --output-on-failure
# or directly:
./mcps_tests
```

### Option B — Simple Makefile (no CMake needed)

```bash
make          # builds ./mcps and ./mcps_tests
make test     # builds and runs tests
make clean    # removes build artefacts
```

### Option C — Direct g++ / clang++ invocation

```bash
# Application
g++ -std=c++17 -O2 -Wall \
    src/main.cpp src/Project.cpp src/Planner.cpp \
    -o mcps

# Tests
g++ -std=c++17 -O2 -Wall \
    tests/test_main.cpp src/Project.cpp src/Planner.cpp \
    -o mcps_tests
```

**Requirements:** Any C++17-compliant compiler (GCC ≥ 7, Clang ≥ 5, MSVC 2017+).

---

## Usage

Launch the application:

```bash
./mcps
```

A demo scenario (8 projects, budget=15, time=12) is pre-loaded so you can immediately press **5** to see the optimal selection.

```
  ╔══════════════════════════════════════════╗
  ║  Multi-Constraint Project Selector       ║
  ╠══════════════════════════════════════════╣
  ║  1  List projects                        ║
  ║  2  Add a project                        ║
  ║  3  Remove a project                     ║
  ║  4  Set constraints (budget / time)      ║
  ║  5  Run DP solver                        ║
  ║  6  Run brute-force solver               ║
  ║  7  Run both + compare                   ║
  ║  8  Load demo scenario                   ║
  ║  0  Exit                                 ║
  ╚══════════════════════════════════════════╝
```

---

## Algorithm Deep-Dive

See [`docs/DESIGN.md`](docs/DESIGN.md) for the full write-up. Summary:

### DP State

```
dp[b][t]  =  maximum profit achievable from projects considered so far,
             using at most b budget units AND at most t time units.
```

### Transition

For each project `i` with cost `c`, time `τ`, profit `p`:

```
for b from B down to c:
    for t from T down to τ:
        dp[b][t] = max(dp[b][t],          // skip project i
                       dp[b-c][t-τ] + p)  // include project i
```

The **reverse iteration** (high → low) ensures each project is used **at most once** (0/1 knapsack property).

### Traceback

A 3-D boolean tensor `sel[i][b][t]` records inclusion decisions. Walking it backwards from `(n-1, B, T)` recovers the exact selected subset.

---

## Complexity Analysis

| Dimension | Value |
|-----------|-------|
| Time      | O(n · B · T) |
| Space     | O(n · B · T) for traceback, O(B · T) for DP table alone |

Where `n` = number of projects, `B` = max budget, `T` = max time.

For the demo scenario (n=8, B=15, T=12): **1,440 DP operations** — instant.

The brute-force solver runs in **O(2ⁿ)** and is provided only for correctness validation on small inputs (n ≤ 25).

---

## Running Tests

```bash
# Via CMake/CTest
cd build && ctest --output-on-failure

# Directly
./mcps_tests
```

**15 tests** covering:
- Project construction, mutators, negative-value rejection
- Planner add/remove, out-of-range guards
- DP edge cases: empty list, zero constraints, single item fits/doesn't fit
- DP correctness vs brute force on the full demo scenario
- Constraint-satisfaction guarantee on selected subsets

---

## Example Output

```
  PROJECT REGISTRY  (8 projects)
  ══════════════════════════════════════════════════════
    #  Name                      Cost    Time    Profit
  ──────────────────────────────────────────────────────
    1  Website Redesign             4       3         7
    2  Mobile App v2                6       4        10
    3  Data Pipeline                3       2         5
    4  AI Chatbot                   7       5        12
    5  Security Audit               2       2         4
    6  CRM Integration              5       3         8
    7  Analytics Dashboard          4       4         6
    8  Cloud Migration              8       6        13
  ──────────────────────────────────────────────────────
  Constraints:  Budget = 15  |  Time = 12

  OPTIMAL SELECTION  (DP 2-D Knapsack)
  ══════════════════════════════════════════════════════
  Name                         Cost    Time    Profit
  ──────────────────────────────────────────────────────
  Mobile App v2                   6       4        10
  Data Pipeline                   3       2         5
  AI Chatbot                      7       5        12
  ──────────────────────────────────────────────────────
  TOTAL                          16      11        27

  Resource Usage:
    Budget : 16 / 15  → constraint respected (DP backtracks correctly)
    Time   : 11 / 12  (91.7% used)
```

---

## Contributing

1. Fork the repository  
2. Create a feature branch (`git checkout -b feature/my-feature`)  
3. Commit your changes (`git commit -m "Add my feature"`)  
4. Push to the branch (`git push origin feature/my-feature`)  
5. Open a Pull Request  

Please ensure all 15 unit tests pass and add new tests for any new behaviour.

---

## License

MIT License — see [`LICENSE`](LICENSE) for details.
