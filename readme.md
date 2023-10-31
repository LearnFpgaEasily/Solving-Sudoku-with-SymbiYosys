# Solving a sudoku with SymbiYosys

This repository contain the source code of the blog post [Solving a Sudoku with SymbiYosys Formal Verification](TODO) written by Theophile from [learn-fpga-easily](https://learn-fpga-easily.com/)

## Prerequisites

### For SymbiYosys and solvers

1. Install oss-cad-suite. You can download it on the [release page](https://github.com/YosysHQ/oss-cad-suite-build/releases).
2. Extract it where you want.
3. Add the location to the PATH variable.
```bash
export PATH="<extracted_location>/oss-cad-suite/bin:$PATH"
```

### Visualization script

1. create a virtual environment:
```
python -m venv .pyenv
```
2. source it
```
source .pyenv/bin/activate
```
3. install pyDigitalWaveTools
```
pip install pyDigitalWaveTools
```

### Run the project

1. To run the verification, run the following command:
```bash
sby -f sudoku.sby
```
2. To print the solution, run:
```bash
python printSudoku.py sudoku/engine_0/trace.vcd
```


