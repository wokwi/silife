# User config
set ::env(DESIGN_NAME) silife_grid_32x32

# Change if needed
set ::env(VERILOG_FILES) "
  $::env(DESIGN_DIR)/src/grid_32x32.v
  $::env(DESIGN_DIR)/src/cell.v
"

# Fill this
set ::env(CLOCK_PERIOD) "20.0"
set ::env(CLOCK_PORT) "clk"

# This is just a macro
set ::env(DESIGN_IS_CORE) 0
set ::env(FP_PDN_CORE_RING) 0
set ::env(GLB_RT_MAXLAYER) 5

set ::env(FP_PIN_ORDER_CFG) $::env(DESIGN_DIR)/pin_order.cfg

set ::env(SYNTH_MAX_FANOUT) 5
set ::env(FP_CORE_UTIL) 45
set ::env(PL_TARGET_DENSITY) [ expr ($::env(FP_CORE_UTIL)+5) / 100.0 ]

set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) 0.2
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) 0.2
