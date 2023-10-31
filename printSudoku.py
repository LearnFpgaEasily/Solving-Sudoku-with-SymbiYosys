'''
Description: Take the vcd file from SymbiYosys verification and print the solved Sudoku
Author: Theophile Loubiere from learn-fpga-easily for YosysHQ
Date Created: 30/10/2023
'''

import json
import sys
from pyDigitalWaveTools.vcd.parser import VcdParser

# ChatGPT generated.

def extract_sudoku_from_json(json_data):
    """Extract the Sudoku grid from the given JSON data."""
    sudoku = [['.' for _ in range(9)] for _ in range(9)]
    
    # Navigate to the 'sudoku' child in the JSON data
    for child in json_data['children']:
        if child['name'] == 'sudoku':
            sudoku_data = child['children']

    # Extract each grid value and place in the appropriate row/column
    for grid in sudoku_data:
        if 'sudoku_grid' in grid['name']:
            # Extract the row and column from the grid name
            grid_name = grid['name'].split('<')[1].split('>')[0]
            row = int(grid_name, 16) // 9
            col = int(grid_name, 16) % 9
            
            # Get the value from the grid data and convert from binary to integer
            value = int(grid['data'][0][1][1:], 2)

            if value != 0:  # Keep dots for zeros
                sudoku[row][col] = str(value)

    return sudoku

def print_sudoku(sudoku):
    """Print the given Sudoku grid."""
    for i, row in enumerate(sudoku):
        if i % 3 == 0 and i != 0:
            print("-" * 21)  # Print a separator every 3 rows
        for j, val in enumerate(row):
            if j % 3 == 0 and j != 0:
                print("|", end=" ")  # Print a separator every 3 columns
            print(val, end=" ")
        print()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        fname = sys.argv[1]
    else:
        print('Give me a vcd file to parse')
        sys.exit(-1)

    with open(fname) as vcd_file:
        with open("trace.json", "w") as f:
            vcd = VcdParser()
            vcd.parse(vcd_file)
            data = vcd.scope.toJson()
            json.dump(data, f)

    # Read the JSON data from the file
    with open('trace.json', 'r') as file:
        data = json.load(file)

    # Extract the Sudoku grid from the JSON data
    sudoku = extract_sudoku_from_json(data)

    # Print the Sudoku grid
    print_sudoku(sudoku)
