  silife_cell cell_0_0 (
      .reset (reset || (row_select == 0 && clear_cells[0])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 0 && set_cells[0]),
      .nw    (i_nw),
      .n     (i_n[0]),
      .ne    (i_n[1]),
      .e     (cell_values[1]),
      .se    (cell_values[9]),
      .s     (cell_values[8]),
      .sw    (i_w[1]),
      .w     (i_w[0]),
      .out   (cell_values[0])
  );
  silife_cell cell_0_1 (
      .reset (reset || (row_select == 0 && clear_cells[1])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 0 && set_cells[1]),
      .nw    (i_n[0]),
      .n     (i_n[1]),
      .ne    (i_n[2]),
      .e     (cell_values[2]),
      .se    (cell_values[10]),
      .s     (cell_values[9]),
      .sw    (cell_values[8]),
      .w     (cell_values[0]),
      .out   (cell_values[1])
  );
  silife_cell cell_0_2 (
      .reset (reset || (row_select == 0 && clear_cells[2])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 0 && set_cells[2]),
      .nw    (i_n[1]),
      .n     (i_n[2]),
      .ne    (i_n[3]),
      .e     (cell_values[3]),
      .se    (cell_values[11]),
      .s     (cell_values[10]),
      .sw    (cell_values[9]),
      .w     (cell_values[1]),
      .out   (cell_values[2])
  );
  silife_cell cell_0_3 (
      .reset (reset || (row_select == 0 && clear_cells[3])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 0 && set_cells[3]),
      .nw    (i_n[2]),
      .n     (i_n[3]),
      .ne    (i_n[4]),
      .e     (cell_values[4]),
      .se    (cell_values[12]),
      .s     (cell_values[11]),
      .sw    (cell_values[10]),
      .w     (cell_values[2]),
      .out   (cell_values[3])
  );
  silife_cell cell_0_4 (
      .reset (reset || (row_select == 0 && clear_cells[4])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 0 && set_cells[4]),
      .nw    (i_n[3]),
      .n     (i_n[4]),
      .ne    (i_n[5]),
      .e     (cell_values[5]),
      .se    (cell_values[13]),
      .s     (cell_values[12]),
      .sw    (cell_values[11]),
      .w     (cell_values[3]),
      .out   (cell_values[4])
  );
  silife_cell cell_0_5 (
      .reset (reset || (row_select == 0 && clear_cells[5])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 0 && set_cells[5]),
      .nw    (i_n[4]),
      .n     (i_n[5]),
      .ne    (i_n[6]),
      .e     (cell_values[6]),
      .se    (cell_values[14]),
      .s     (cell_values[13]),
      .sw    (cell_values[12]),
      .w     (cell_values[4]),
      .out   (cell_values[5])
  );
  silife_cell cell_0_6 (
      .reset (reset || (row_select == 0 && clear_cells[6])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 0 && set_cells[6]),
      .nw    (i_n[5]),
      .n     (i_n[6]),
      .ne    (i_n[7]),
      .e     (cell_values[7]),
      .se    (cell_values[15]),
      .s     (cell_values[14]),
      .sw    (cell_values[13]),
      .w     (cell_values[5]),
      .out   (cell_values[6])
  );
  silife_cell cell_0_7 (
      .reset (reset || (row_select == 0 && clear_cells[7])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 0 && set_cells[7]),
      .nw    (i_n[6]),
      .n     (i_n[7]),
      .ne    (i_ne),
      .e     (i_e[0]),
      .se    (i_e[1]),
      .s     (cell_values[15]),
      .sw    (cell_values[14]),
      .w     (cell_values[6]),
      .out   (cell_values[7])
  );
  silife_cell cell_1_0 (
      .reset (reset || (row_select == 1 && clear_cells[0])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 1 && set_cells[0]),
      .nw    (i_w[0]),
      .n     (cell_values[0]),
      .ne    (cell_values[1]),
      .e     (cell_values[9]),
      .se    (cell_values[17]),
      .s     (cell_values[16]),
      .sw    (i_w[2]),
      .w     (i_w[1]),
      .out   (cell_values[8])
  );
  silife_cell cell_1_1 (
      .reset (reset || (row_select == 1 && clear_cells[1])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 1 && set_cells[1]),
      .nw    (cell_values[0]),
      .n     (cell_values[1]),
      .ne    (cell_values[2]),
      .e     (cell_values[10]),
      .se    (cell_values[18]),
      .s     (cell_values[17]),
      .sw    (cell_values[16]),
      .w     (cell_values[8]),
      .out   (cell_values[9])
  );
  silife_cell cell_1_2 (
      .reset (reset || (row_select == 1 && clear_cells[2])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 1 && set_cells[2]),
      .nw    (cell_values[1]),
      .n     (cell_values[2]),
      .ne    (cell_values[3]),
      .e     (cell_values[11]),
      .se    (cell_values[19]),
      .s     (cell_values[18]),
      .sw    (cell_values[17]),
      .w     (cell_values[9]),
      .out   (cell_values[10])
  );
  silife_cell cell_1_3 (
      .reset (reset || (row_select == 1 && clear_cells[3])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 1 && set_cells[3]),
      .nw    (cell_values[2]),
      .n     (cell_values[3]),
      .ne    (cell_values[4]),
      .e     (cell_values[12]),
      .se    (cell_values[20]),
      .s     (cell_values[19]),
      .sw    (cell_values[18]),
      .w     (cell_values[10]),
      .out   (cell_values[11])
  );
  silife_cell cell_1_4 (
      .reset (reset || (row_select == 1 && clear_cells[4])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 1 && set_cells[4]),
      .nw    (cell_values[3]),
      .n     (cell_values[4]),
      .ne    (cell_values[5]),
      .e     (cell_values[13]),
      .se    (cell_values[21]),
      .s     (cell_values[20]),
      .sw    (cell_values[19]),
      .w     (cell_values[11]),
      .out   (cell_values[12])
  );
  silife_cell cell_1_5 (
      .reset (reset || (row_select == 1 && clear_cells[5])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 1 && set_cells[5]),
      .nw    (cell_values[4]),
      .n     (cell_values[5]),
      .ne    (cell_values[6]),
      .e     (cell_values[14]),
      .se    (cell_values[22]),
      .s     (cell_values[21]),
      .sw    (cell_values[20]),
      .w     (cell_values[12]),
      .out   (cell_values[13])
  );
  silife_cell cell_1_6 (
      .reset (reset || (row_select == 1 && clear_cells[6])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 1 && set_cells[6]),
      .nw    (cell_values[5]),
      .n     (cell_values[6]),
      .ne    (cell_values[7]),
      .e     (cell_values[15]),
      .se    (cell_values[23]),
      .s     (cell_values[22]),
      .sw    (cell_values[21]),
      .w     (cell_values[13]),
      .out   (cell_values[14])
  );
  silife_cell cell_1_7 (
      .reset (reset || (row_select == 1 && clear_cells[7])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 1 && set_cells[7]),
      .nw    (cell_values[6]),
      .n     (cell_values[7]),
      .ne    (i_e[0]),
      .e     (i_e[1]),
      .se    (i_e[2]),
      .s     (cell_values[23]),
      .sw    (cell_values[22]),
      .w     (cell_values[14]),
      .out   (cell_values[15])
  );
  silife_cell cell_2_0 (
      .reset (reset || (row_select == 2 && clear_cells[0])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 2 && set_cells[0]),
      .nw    (i_w[1]),
      .n     (cell_values[8]),
      .ne    (cell_values[9]),
      .e     (cell_values[17]),
      .se    (cell_values[25]),
      .s     (cell_values[24]),
      .sw    (i_w[3]),
      .w     (i_w[2]),
      .out   (cell_values[16])
  );
  silife_cell cell_2_1 (
      .reset (reset || (row_select == 2 && clear_cells[1])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 2 && set_cells[1]),
      .nw    (cell_values[8]),
      .n     (cell_values[9]),
      .ne    (cell_values[10]),
      .e     (cell_values[18]),
      .se    (cell_values[26]),
      .s     (cell_values[25]),
      .sw    (cell_values[24]),
      .w     (cell_values[16]),
      .out   (cell_values[17])
  );
  silife_cell cell_2_2 (
      .reset (reset || (row_select == 2 && clear_cells[2])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 2 && set_cells[2]),
      .nw    (cell_values[9]),
      .n     (cell_values[10]),
      .ne    (cell_values[11]),
      .e     (cell_values[19]),
      .se    (cell_values[27]),
      .s     (cell_values[26]),
      .sw    (cell_values[25]),
      .w     (cell_values[17]),
      .out   (cell_values[18])
  );
  silife_cell cell_2_3 (
      .reset (reset || (row_select == 2 && clear_cells[3])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 2 && set_cells[3]),
      .nw    (cell_values[10]),
      .n     (cell_values[11]),
      .ne    (cell_values[12]),
      .e     (cell_values[20]),
      .se    (cell_values[28]),
      .s     (cell_values[27]),
      .sw    (cell_values[26]),
      .w     (cell_values[18]),
      .out   (cell_values[19])
  );
  silife_cell cell_2_4 (
      .reset (reset || (row_select == 2 && clear_cells[4])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 2 && set_cells[4]),
      .nw    (cell_values[11]),
      .n     (cell_values[12]),
      .ne    (cell_values[13]),
      .e     (cell_values[21]),
      .se    (cell_values[29]),
      .s     (cell_values[28]),
      .sw    (cell_values[27]),
      .w     (cell_values[19]),
      .out   (cell_values[20])
  );
  silife_cell cell_2_5 (
      .reset (reset || (row_select == 2 && clear_cells[5])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 2 && set_cells[5]),
      .nw    (cell_values[12]),
      .n     (cell_values[13]),
      .ne    (cell_values[14]),
      .e     (cell_values[22]),
      .se    (cell_values[30]),
      .s     (cell_values[29]),
      .sw    (cell_values[28]),
      .w     (cell_values[20]),
      .out   (cell_values[21])
  );
  silife_cell cell_2_6 (
      .reset (reset || (row_select == 2 && clear_cells[6])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 2 && set_cells[6]),
      .nw    (cell_values[13]),
      .n     (cell_values[14]),
      .ne    (cell_values[15]),
      .e     (cell_values[23]),
      .se    (cell_values[31]),
      .s     (cell_values[30]),
      .sw    (cell_values[29]),
      .w     (cell_values[21]),
      .out   (cell_values[22])
  );
  silife_cell cell_2_7 (
      .reset (reset || (row_select == 2 && clear_cells[7])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 2 && set_cells[7]),
      .nw    (cell_values[14]),
      .n     (cell_values[15]),
      .ne    (i_e[1]),
      .e     (i_e[2]),
      .se    (i_e[3]),
      .s     (cell_values[31]),
      .sw    (cell_values[30]),
      .w     (cell_values[22]),
      .out   (cell_values[23])
  );
  silife_cell cell_3_0 (
      .reset (reset || (row_select == 3 && clear_cells[0])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 3 && set_cells[0]),
      .nw    (i_w[2]),
      .n     (cell_values[16]),
      .ne    (cell_values[17]),
      .e     (cell_values[25]),
      .se    (cell_values[33]),
      .s     (cell_values[32]),
      .sw    (i_w[4]),
      .w     (i_w[3]),
      .out   (cell_values[24])
  );
  silife_cell cell_3_1 (
      .reset (reset || (row_select == 3 && clear_cells[1])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 3 && set_cells[1]),
      .nw    (cell_values[16]),
      .n     (cell_values[17]),
      .ne    (cell_values[18]),
      .e     (cell_values[26]),
      .se    (cell_values[34]),
      .s     (cell_values[33]),
      .sw    (cell_values[32]),
      .w     (cell_values[24]),
      .out   (cell_values[25])
  );
  silife_cell cell_3_2 (
      .reset (reset || (row_select == 3 && clear_cells[2])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 3 && set_cells[2]),
      .nw    (cell_values[17]),
      .n     (cell_values[18]),
      .ne    (cell_values[19]),
      .e     (cell_values[27]),
      .se    (cell_values[35]),
      .s     (cell_values[34]),
      .sw    (cell_values[33]),
      .w     (cell_values[25]),
      .out   (cell_values[26])
  );
  silife_cell cell_3_3 (
      .reset (reset || (row_select == 3 && clear_cells[3])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 3 && set_cells[3]),
      .nw    (cell_values[18]),
      .n     (cell_values[19]),
      .ne    (cell_values[20]),
      .e     (cell_values[28]),
      .se    (cell_values[36]),
      .s     (cell_values[35]),
      .sw    (cell_values[34]),
      .w     (cell_values[26]),
      .out   (cell_values[27])
  );
  silife_cell cell_3_4 (
      .reset (reset || (row_select == 3 && clear_cells[4])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 3 && set_cells[4]),
      .nw    (cell_values[19]),
      .n     (cell_values[20]),
      .ne    (cell_values[21]),
      .e     (cell_values[29]),
      .se    (cell_values[37]),
      .s     (cell_values[36]),
      .sw    (cell_values[35]),
      .w     (cell_values[27]),
      .out   (cell_values[28])
  );
  silife_cell cell_3_5 (
      .reset (reset || (row_select == 3 && clear_cells[5])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 3 && set_cells[5]),
      .nw    (cell_values[20]),
      .n     (cell_values[21]),
      .ne    (cell_values[22]),
      .e     (cell_values[30]),
      .se    (cell_values[38]),
      .s     (cell_values[37]),
      .sw    (cell_values[36]),
      .w     (cell_values[28]),
      .out   (cell_values[29])
  );
  silife_cell cell_3_6 (
      .reset (reset || (row_select == 3 && clear_cells[6])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 3 && set_cells[6]),
      .nw    (cell_values[21]),
      .n     (cell_values[22]),
      .ne    (cell_values[23]),
      .e     (cell_values[31]),
      .se    (cell_values[39]),
      .s     (cell_values[38]),
      .sw    (cell_values[37]),
      .w     (cell_values[29]),
      .out   (cell_values[30])
  );
  silife_cell cell_3_7 (
      .reset (reset || (row_select == 3 && clear_cells[7])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 3 && set_cells[7]),
      .nw    (cell_values[22]),
      .n     (cell_values[23]),
      .ne    (i_e[2]),
      .e     (i_e[3]),
      .se    (i_e[4]),
      .s     (cell_values[39]),
      .sw    (cell_values[38]),
      .w     (cell_values[30]),
      .out   (cell_values[31])
  );
  silife_cell cell_4_0 (
      .reset (reset || (row_select == 4 && clear_cells[0])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 4 && set_cells[0]),
      .nw    (i_w[3]),
      .n     (cell_values[24]),
      .ne    (cell_values[25]),
      .e     (cell_values[33]),
      .se    (cell_values[41]),
      .s     (cell_values[40]),
      .sw    (i_w[5]),
      .w     (i_w[4]),
      .out   (cell_values[32])
  );
  silife_cell cell_4_1 (
      .reset (reset || (row_select == 4 && clear_cells[1])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 4 && set_cells[1]),
      .nw    (cell_values[24]),
      .n     (cell_values[25]),
      .ne    (cell_values[26]),
      .e     (cell_values[34]),
      .se    (cell_values[42]),
      .s     (cell_values[41]),
      .sw    (cell_values[40]),
      .w     (cell_values[32]),
      .out   (cell_values[33])
  );
  silife_cell cell_4_2 (
      .reset (reset || (row_select == 4 && clear_cells[2])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 4 && set_cells[2]),
      .nw    (cell_values[25]),
      .n     (cell_values[26]),
      .ne    (cell_values[27]),
      .e     (cell_values[35]),
      .se    (cell_values[43]),
      .s     (cell_values[42]),
      .sw    (cell_values[41]),
      .w     (cell_values[33]),
      .out   (cell_values[34])
  );
  silife_cell cell_4_3 (
      .reset (reset || (row_select == 4 && clear_cells[3])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 4 && set_cells[3]),
      .nw    (cell_values[26]),
      .n     (cell_values[27]),
      .ne    (cell_values[28]),
      .e     (cell_values[36]),
      .se    (cell_values[44]),
      .s     (cell_values[43]),
      .sw    (cell_values[42]),
      .w     (cell_values[34]),
      .out   (cell_values[35])
  );
  silife_cell cell_4_4 (
      .reset (reset || (row_select == 4 && clear_cells[4])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 4 && set_cells[4]),
      .nw    (cell_values[27]),
      .n     (cell_values[28]),
      .ne    (cell_values[29]),
      .e     (cell_values[37]),
      .se    (cell_values[45]),
      .s     (cell_values[44]),
      .sw    (cell_values[43]),
      .w     (cell_values[35]),
      .out   (cell_values[36])
  );
  silife_cell cell_4_5 (
      .reset (reset || (row_select == 4 && clear_cells[5])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 4 && set_cells[5]),
      .nw    (cell_values[28]),
      .n     (cell_values[29]),
      .ne    (cell_values[30]),
      .e     (cell_values[38]),
      .se    (cell_values[46]),
      .s     (cell_values[45]),
      .sw    (cell_values[44]),
      .w     (cell_values[36]),
      .out   (cell_values[37])
  );
  silife_cell cell_4_6 (
      .reset (reset || (row_select == 4 && clear_cells[6])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 4 && set_cells[6]),
      .nw    (cell_values[29]),
      .n     (cell_values[30]),
      .ne    (cell_values[31]),
      .e     (cell_values[39]),
      .se    (cell_values[47]),
      .s     (cell_values[46]),
      .sw    (cell_values[45]),
      .w     (cell_values[37]),
      .out   (cell_values[38])
  );
  silife_cell cell_4_7 (
      .reset (reset || (row_select == 4 && clear_cells[7])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 4 && set_cells[7]),
      .nw    (cell_values[30]),
      .n     (cell_values[31]),
      .ne    (i_e[3]),
      .e     (i_e[4]),
      .se    (i_e[5]),
      .s     (cell_values[47]),
      .sw    (cell_values[46]),
      .w     (cell_values[38]),
      .out   (cell_values[39])
  );
  silife_cell cell_5_0 (
      .reset (reset || (row_select == 5 && clear_cells[0])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 5 && set_cells[0]),
      .nw    (i_w[4]),
      .n     (cell_values[32]),
      .ne    (cell_values[33]),
      .e     (cell_values[41]),
      .se    (cell_values[49]),
      .s     (cell_values[48]),
      .sw    (i_w[6]),
      .w     (i_w[5]),
      .out   (cell_values[40])
  );
  silife_cell cell_5_1 (
      .reset (reset || (row_select == 5 && clear_cells[1])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 5 && set_cells[1]),
      .nw    (cell_values[32]),
      .n     (cell_values[33]),
      .ne    (cell_values[34]),
      .e     (cell_values[42]),
      .se    (cell_values[50]),
      .s     (cell_values[49]),
      .sw    (cell_values[48]),
      .w     (cell_values[40]),
      .out   (cell_values[41])
  );
  silife_cell cell_5_2 (
      .reset (reset || (row_select == 5 && clear_cells[2])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 5 && set_cells[2]),
      .nw    (cell_values[33]),
      .n     (cell_values[34]),
      .ne    (cell_values[35]),
      .e     (cell_values[43]),
      .se    (cell_values[51]),
      .s     (cell_values[50]),
      .sw    (cell_values[49]),
      .w     (cell_values[41]),
      .out   (cell_values[42])
  );
  silife_cell cell_5_3 (
      .reset (reset || (row_select == 5 && clear_cells[3])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 5 && set_cells[3]),
      .nw    (cell_values[34]),
      .n     (cell_values[35]),
      .ne    (cell_values[36]),
      .e     (cell_values[44]),
      .se    (cell_values[52]),
      .s     (cell_values[51]),
      .sw    (cell_values[50]),
      .w     (cell_values[42]),
      .out   (cell_values[43])
  );
  silife_cell cell_5_4 (
      .reset (reset || (row_select == 5 && clear_cells[4])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 5 && set_cells[4]),
      .nw    (cell_values[35]),
      .n     (cell_values[36]),
      .ne    (cell_values[37]),
      .e     (cell_values[45]),
      .se    (cell_values[53]),
      .s     (cell_values[52]),
      .sw    (cell_values[51]),
      .w     (cell_values[43]),
      .out   (cell_values[44])
  );
  silife_cell cell_5_5 (
      .reset (reset || (row_select == 5 && clear_cells[5])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 5 && set_cells[5]),
      .nw    (cell_values[36]),
      .n     (cell_values[37]),
      .ne    (cell_values[38]),
      .e     (cell_values[46]),
      .se    (cell_values[54]),
      .s     (cell_values[53]),
      .sw    (cell_values[52]),
      .w     (cell_values[44]),
      .out   (cell_values[45])
  );
  silife_cell cell_5_6 (
      .reset (reset || (row_select == 5 && clear_cells[6])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 5 && set_cells[6]),
      .nw    (cell_values[37]),
      .n     (cell_values[38]),
      .ne    (cell_values[39]),
      .e     (cell_values[47]),
      .se    (cell_values[55]),
      .s     (cell_values[54]),
      .sw    (cell_values[53]),
      .w     (cell_values[45]),
      .out   (cell_values[46])
  );
  silife_cell cell_5_7 (
      .reset (reset || (row_select == 5 && clear_cells[7])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 5 && set_cells[7]),
      .nw    (cell_values[38]),
      .n     (cell_values[39]),
      .ne    (i_e[4]),
      .e     (i_e[5]),
      .se    (i_e[6]),
      .s     (cell_values[55]),
      .sw    (cell_values[54]),
      .w     (cell_values[46]),
      .out   (cell_values[47])
  );
  silife_cell cell_6_0 (
      .reset (reset || (row_select == 6 && clear_cells[0])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 6 && set_cells[0]),
      .nw    (i_w[5]),
      .n     (cell_values[40]),
      .ne    (cell_values[41]),
      .e     (cell_values[49]),
      .se    (cell_values[57]),
      .s     (cell_values[56]),
      .sw    (i_w[7]),
      .w     (i_w[6]),
      .out   (cell_values[48])
  );
  silife_cell cell_6_1 (
      .reset (reset || (row_select == 6 && clear_cells[1])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 6 && set_cells[1]),
      .nw    (cell_values[40]),
      .n     (cell_values[41]),
      .ne    (cell_values[42]),
      .e     (cell_values[50]),
      .se    (cell_values[58]),
      .s     (cell_values[57]),
      .sw    (cell_values[56]),
      .w     (cell_values[48]),
      .out   (cell_values[49])
  );
  silife_cell cell_6_2 (
      .reset (reset || (row_select == 6 && clear_cells[2])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 6 && set_cells[2]),
      .nw    (cell_values[41]),
      .n     (cell_values[42]),
      .ne    (cell_values[43]),
      .e     (cell_values[51]),
      .se    (cell_values[59]),
      .s     (cell_values[58]),
      .sw    (cell_values[57]),
      .w     (cell_values[49]),
      .out   (cell_values[50])
  );
  silife_cell cell_6_3 (
      .reset (reset || (row_select == 6 && clear_cells[3])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 6 && set_cells[3]),
      .nw    (cell_values[42]),
      .n     (cell_values[43]),
      .ne    (cell_values[44]),
      .e     (cell_values[52]),
      .se    (cell_values[60]),
      .s     (cell_values[59]),
      .sw    (cell_values[58]),
      .w     (cell_values[50]),
      .out   (cell_values[51])
  );
  silife_cell cell_6_4 (
      .reset (reset || (row_select == 6 && clear_cells[4])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 6 && set_cells[4]),
      .nw    (cell_values[43]),
      .n     (cell_values[44]),
      .ne    (cell_values[45]),
      .e     (cell_values[53]),
      .se    (cell_values[61]),
      .s     (cell_values[60]),
      .sw    (cell_values[59]),
      .w     (cell_values[51]),
      .out   (cell_values[52])
  );
  silife_cell cell_6_5 (
      .reset (reset || (row_select == 6 && clear_cells[5])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 6 && set_cells[5]),
      .nw    (cell_values[44]),
      .n     (cell_values[45]),
      .ne    (cell_values[46]),
      .e     (cell_values[54]),
      .se    (cell_values[62]),
      .s     (cell_values[61]),
      .sw    (cell_values[60]),
      .w     (cell_values[52]),
      .out   (cell_values[53])
  );
  silife_cell cell_6_6 (
      .reset (reset || (row_select == 6 && clear_cells[6])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 6 && set_cells[6]),
      .nw    (cell_values[45]),
      .n     (cell_values[46]),
      .ne    (cell_values[47]),
      .e     (cell_values[55]),
      .se    (cell_values[63]),
      .s     (cell_values[62]),
      .sw    (cell_values[61]),
      .w     (cell_values[53]),
      .out   (cell_values[54])
  );
  silife_cell cell_6_7 (
      .reset (reset || (row_select == 6 && clear_cells[7])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 6 && set_cells[7]),
      .nw    (cell_values[46]),
      .n     (cell_values[47]),
      .ne    (i_e[5]),
      .e     (i_e[6]),
      .se    (i_e[7]),
      .s     (cell_values[63]),
      .sw    (cell_values[62]),
      .w     (cell_values[54]),
      .out   (cell_values[55])
  );
  silife_cell cell_7_0 (
      .reset (reset || (row_select == 7 && clear_cells[0])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 7 && set_cells[0]),
      .nw    (i_w[6]),
      .n     (cell_values[48]),
      .ne    (cell_values[49]),
      .e     (cell_values[57]),
      .se    (i_s[65]),
      .s     (i_s[64]),
      .sw    (i_sw),
      .w     (i_w[7]),
      .out   (cell_values[56])
  );
  silife_cell cell_7_1 (
      .reset (reset || (row_select == 7 && clear_cells[1])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 7 && set_cells[1]),
      .nw    (cell_values[48]),
      .n     (cell_values[49]),
      .ne    (cell_values[50]),
      .e     (cell_values[58]),
      .se    (i_s[66]),
      .s     (i_s[65]),
      .sw    (i_s[64]),
      .w     (cell_values[56]),
      .out   (cell_values[57])
  );
  silife_cell cell_7_2 (
      .reset (reset || (row_select == 7 && clear_cells[2])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 7 && set_cells[2]),
      .nw    (cell_values[49]),
      .n     (cell_values[50]),
      .ne    (cell_values[51]),
      .e     (cell_values[59]),
      .se    (i_s[67]),
      .s     (i_s[66]),
      .sw    (i_s[65]),
      .w     (cell_values[57]),
      .out   (cell_values[58])
  );
  silife_cell cell_7_3 (
      .reset (reset || (row_select == 7 && clear_cells[3])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 7 && set_cells[3]),
      .nw    (cell_values[50]),
      .n     (cell_values[51]),
      .ne    (cell_values[52]),
      .e     (cell_values[60]),
      .se    (i_s[68]),
      .s     (i_s[67]),
      .sw    (i_s[66]),
      .w     (cell_values[58]),
      .out   (cell_values[59])
  );
  silife_cell cell_7_4 (
      .reset (reset || (row_select == 7 && clear_cells[4])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 7 && set_cells[4]),
      .nw    (cell_values[51]),
      .n     (cell_values[52]),
      .ne    (cell_values[53]),
      .e     (cell_values[61]),
      .se    (i_s[69]),
      .s     (i_s[68]),
      .sw    (i_s[67]),
      .w     (cell_values[59]),
      .out   (cell_values[60])
  );
  silife_cell cell_7_5 (
      .reset (reset || (row_select == 7 && clear_cells[5])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 7 && set_cells[5]),
      .nw    (cell_values[52]),
      .n     (cell_values[53]),
      .ne    (cell_values[54]),
      .e     (cell_values[62]),
      .se    (i_s[70]),
      .s     (i_s[69]),
      .sw    (i_s[68]),
      .w     (cell_values[60]),
      .out   (cell_values[61])
  );
  silife_cell cell_7_6 (
      .reset (reset || (row_select == 7 && clear_cells[6])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 7 && set_cells[6]),
      .nw    (cell_values[53]),
      .n     (cell_values[54]),
      .ne    (cell_values[55]),
      .e     (cell_values[63]),
      .se    (i_s[71]),
      .s     (i_s[70]),
      .sw    (i_s[69]),
      .w     (cell_values[61]),
      .out   (cell_values[62])
  );
  silife_cell cell_7_7 (
      .reset (reset || (row_select == 7 && clear_cells[7])),
      .clk   (clk),
      .enable(enable),
      .revive(row_select == 7 && set_cells[7]),
      .nw    (cell_values[54]),
      .n     (cell_values[55]),
      .ne    (i_e[6]),
      .e     (i_e[7]),
      .se    (i_se),
      .s     (i_s[71]),
      .sw    (i_s[70]),
      .w     (cell_values[62]),
      .out   (cell_values[63])
  );