import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotbext.wishbone.driver import WishboneMaster, WBOp


def bit(b):
    return 1 << b


# Matrix configuration
matrix_height = 8
matrix_width = 8

# Wishbone bus registers
reg_ctrl = 0x3000_0000
REG_CTRL_EN = bit(0)
REG_CTRL_PULSE = bit(1)

reg_max7219_ctrl = 0x3000_0010
REG_MAX7219_EN = bit(0)
REG_MAX7219_PAUSE = bit(1)
REG_MAX7219_FRAME = bit(2)
REG_MAX7219_BUSY = bit(3)

reg_max7219_config = 0x3000_0014
REG_MAX7219_REVERSE_COLS = bit(0)
REG_MAX7219_SERPENTINE = bit(1)

reg_max7219_brightness = 0x3000_0018

wb_matrix_start = 0x3000_1000

wishbone_signals = {
    "cyc": "i_wb_cyc",
    "stb": "i_wb_stb",
    "we": "i_wb_we",
    "adr": "i_wb_addr",
    "datwr": "i_wb_data",
    "datrd": "o_wb_data",
    "ack": "o_wb_ack",
}


async def reset(dut):
    dut.reset.value = 1
    await ClockCycles(dut.clk, 5)
    dut.reset.value = 0
    await ClockCycles(dut.clk, 5)


async def make_clock(dut, clock_mhz):
    clk_period_ns = round(1 / clock_mhz * 1000, 2)
    dut._log.info("input clock = %d MHz, period = %.2f ns" % (clock_mhz, clk_period_ns))
    clock = Clock(dut.clk, clk_period_ns, units="ns")
    clock_sig = cocotb.fork(clock.start())
    return clock_sig


class SiLifeController:
    def __init__(self, dut, wishbone):
        self._dut = dut
        self._wishbone = wishbone

    async def wb_read(self, addr):
        res = await self._wishbone.send_cycle([WBOp(addr)])
        return res[0].datrd

    async def wb_write(self, addr, value):
        await self._wishbone.send_cycle([WBOp(addr, value)])

    async def write_matrix(self, matrix):
        value = 0
        bit_index = 0
        word_offset = 0
        for row in matrix:
            for col in row:
                if col != " ":
                    value |= bit(bit_index)
                bit_index += 1
            await self.wb_write(wb_matrix_start + word_offset, value)
            word_offset += 4
            bit_index = 0
            value = 0

    async def read_matrix(self):
        result = []
        for row_index in range(matrix_height):
            value = await self.wb_read(wb_matrix_start + row_index * 4)
            row = ""
            for bit_index in range(matrix_height):
                if value & bit(bit_index):
                    row += "*"
                else:
                    row += " "
            result.append(row)
        return result


async def create_silife(dut):
    if hasattr(dut, "VPWR"):
        # Running a gate-level simulation, connect the power and ground signals
        dut.VGND <= 0
        dut.VPWR <= 1

    wishbone = WishboneMaster(
        dut, "", dut.clk, width=32, timeout=10, signals_dict=wishbone_signals
    )
    silife = SiLifeController(dut, wishbone)
    return silife


@cocotb.test()
async def test_life(dut):
    max7219_cfg = REG_MAX7219_REVERSE_COLS | REG_MAX7219_SERPENTINE
    silife = await create_silife(dut)
    clock_sig = await make_clock(dut, 10)
    await reset(dut)

    # Disable the Game of Life
    await silife.wb_write(reg_ctrl, 0)

    # Enable MAX7219 output (setting brightness to 12 out of 15)
    await silife.wb_write(reg_max7219_brightness, 12)
    await silife.wb_write(reg_max7219_config, max7219_cfg)
    await silife.wb_write(reg_max7219_ctrl, REG_MAX7219_EN)

    # Write a matrix with some initial state
    await silife.wb_write(wb_matrix_start, 0x55)
    await silife.wb_write(wb_matrix_start + 4, 0x78)

    # Assert that we read the same state back
    assert await silife.wb_read(wb_matrix_start) == 0x55
    assert await silife.wb_read(wb_matrix_start + 4) == 0x78

    # Now load a block with two blinkers
    await silife.write_matrix(
        [
            "        ",
            " ***    ",
            "        ",
            "     *  ",
            "     *  ",
            "     *  ",
            "**      ",
            "**      ",
        ]
    )

    # Run one step, observe the result
    await silife.wb_write(reg_ctrl, REG_CTRL_PULSE)
    assert await silife.read_matrix() == [
        "  *     ",
        "  *     ",
        "  *     ",
        "        ",
        "    *** ",
        "        ",
        "**      ",
        "**      ",
    ]

    # One more step - we should be back to the initial state
    await silife.wb_write(reg_ctrl, REG_CTRL_PULSE)
    assert await silife.read_matrix() == [
        "        ",
        " ***    ",
        "        ",
        "     *  ",
        "     *  ",
        "     *  ",
        "**      ",
        "**      ",
    ]

    clock_sig.kill()
