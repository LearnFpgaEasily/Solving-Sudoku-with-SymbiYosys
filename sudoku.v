//
// Module Name: Sudoku 
// Description: A Sudoku grid model by a register to be formally solved with SymbiYosys
//            
// Author: Theophile Loubiere from learn-fpga-easily for YosysHQ blog.
// Date Created: 30/10/2023

module sudoku (
    input clk,                                  // Clock input
    output reg [323:0] output_grid_flat         // 9x9 array of 4 bits for output flattened to 324 bits
);

    // Internal 9x9 grid to make operations more intuitive
    reg [3:0] sudoku_grid[8:0][8:0];

    // Mapping sudoku grid to an output to avoid deletion during synthesis
    // and be compatible with verilog 2005
    always @(posedge clk) begin
        integer i, j;
        for(i=0; i<9; i=i+1) begin
            for(j=0; j<9; j=j+1) begin
                output_grid_flat[i*9*4+j*4+:4] = sudoku_grid[i][j];
            end
        end
    end

    `ifdef FORMAL
    // declaration of for loop variables
    genvar box_row, box_col, i, j, k, m, n;

    // assume all the digits are between 1 and 9
    generate
        for(i = 0; i < 9; i = i + 1) begin : digit_assumption_i
            for(j = 0; j < 9; j = j + 1) begin: digit_assumption_j
                always @(posedge clk) begin
                    assume(sudoku_grid[i][j] <= 4'd9); 
                    assume(sudoku_grid[i][j] >= 4'd1);
                end
            end
        end 
    endgenerate
    

    // assume all digits in a row are all different
    generate
        for(i = 0; i < 9; i = i + 1) begin: row_check
            for(j = 0; j < 9; j = j + 1) begin: column_j
                for(k = j + 1; k < 9; k = k + 1) begin: column_k
                    always @(posedge clk) begin
                        assume(sudoku_grid[i][j] !== sudoku_grid[i][k]);
                    end
                end
            end
        end 
    endgenerate

    // assume all digits in a column are all different
    generate
        for(i = 0; i < 9; i = i + 1) begin: column_check
            for(j = 0; j < 9; j = j + 1) begin: row_j
                for(k = j + 1; k < 9; k = k + 1) begin: row_k
                    always @(posedge clk) begin
                        assume(sudoku_grid[j][i] !== sudoku_grid[k][i]);
                    end
                end
            end
        end
    endgenerate
    

   // assume all digits in a square are all different
    generate
        for(box_row = 0; box_row < 3; box_row = box_row + 1) begin: box_row_check
            for(box_col = 0; box_col < 3; box_col = box_col + 1) begin: box_col_check
                for(i = 0; i < 3; i = i + 1) begin: row_i_check
                    for(j = 0; j < 3; j = j + 1) begin: col_j_check
                        for(m = 0; m < 3; m = m + 1) begin: row_m_check
                            for(n = 0; n < 3; n = n + 1) begin: col_n_check
                                if(i !== m || j !== n) begin // Make sure we're not comparing the same cell to itself
                                    always @(posedge clk) begin
                                        assume(sudoku_grid[(3*box_row)+i][(3*box_col)+j] !== sudoku_grid[(3*box_row)+m][(3*box_col)+n]);
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    endgenerate

    // assume the intial grid
    always @(posedge clk) begin : initialization
        //line 1
        assume(sudoku_grid[0][0]==5);
        assume(sudoku_grid[0][2]==7);
        assume(sudoku_grid[0][3]==2);
        assume(sudoku_grid[0][7]==9);
        //line 2
        assume(sudoku_grid[1][2]==6);
        assume(sudoku_grid[1][4]==3);
        assume(sudoku_grid[1][6]==7);
        assume(sudoku_grid[1][8]==1);
        //line 3
        assume(sudoku_grid[2][0]==4);
        assume(sudoku_grid[2][7]==6);
        //line 4
        assume(sudoku_grid[3][0]==1);
        assume(sudoku_grid[3][3]==4);
        assume(sudoku_grid[3][4]==9);
        assume(sudoku_grid[3][8]==7);
        //line 5
        assume(sudoku_grid[4][3]==5);
        assume(sudoku_grid[4][5]==8);
        //line 6
        assume(sudoku_grid[5][0]==8);
        assume(sudoku_grid[5][4]==2);
        assume(sudoku_grid[5][5]==7);
        assume(sudoku_grid[5][8]==5);
        //line 7
        assume(sudoku_grid[6][1]==7);
        assume(sudoku_grid[6][8]==9);
        //line 8
        assume(sudoku_grid[7][0]==2);
        assume(sudoku_grid[7][2]==9);
        assume(sudoku_grid[7][4]==8);
        assume(sudoku_grid[7][6]==6);
        //line 9
        assume(sudoku_grid[8][1]==4);
        assume(sudoku_grid[8][5]==9);
        assume(sudoku_grid[8][6]==3);
        assume(sudoku_grid[8][8]==8);
    end

    // Assert that "sum" cannot be equal to 45
    wire [5:0] sum;
    assign sum = sudoku_grid[0][0] +
                 sudoku_grid[0][1] +
                 sudoku_grid[0][2] +
                 sudoku_grid[0][3] +
                 sudoku_grid[0][4] +
                 sudoku_grid[0][5] +
                 sudoku_grid[0][6] +
                 sudoku_grid[0][7] +
                 sudoku_grid[0][8];

    always @(*) begin
        assert(sum!=6'd45);
    end
    `endif
endmodule