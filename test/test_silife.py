import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotbext.wishbone.driver import WishboneMaster, WBOp
from math import ceil


def bit(b): return 1 << b


# Matrix configuration
matrix_height = 8
matrix_width = 8

# Wishbone bus registers
reg_ctrl = 0x3000_0000
REG_CTRL_EN = bit(0)
REG_CTRL_INVERT = bit(1)
REG_CTRL_PULSE = bit(2)
wb_matrix_start = 0x3000_1000

wishbone_signals = {
    "cyc":  "i_wb_cyc",
    "stb":  "i_wb_stb",
    "we":   "i_wb_we",
    "adr":  "i_wb_addr",
    "datwr": "i_wb_data",
    "datrd": "o_wb_data",
    "ack":  "o_wb_ack"
}


async def reset(dut):
    dut.reset.value = 1
    await ClockCycles(dut.clk, 5)
    dut.reset.value = 0
    await ClockCycles(dut.clk, 5)


async def make_clock(dut, clock_mhz):
    clk_period_ns = round(1 / clock_mhz * 1000, 2)
    dut._log.info("input clock = %d MHz, period = %.2f ns" %
                  (clock_mhz, clk_period_ns))
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
        word_offset = 0
        bit_index = 0
        for row in matrix:
            for col in row:
                if col != ' ':
                    value |= bit(bit_index)
                bit_index += 1
                if bit_index == 32:
                    await self.wb_write(wb_matrix_start + word_offset, value)
                    value = 0
                    bit_index = 0
                    word_offset += 4
        if bit_index > 0:
            value = await self.wb_write(wb_matrix_start + word_offset, value)

    async def read_matrix(self):
        result = []
        matrix_words = ceil(matrix_width * matrix_height / 32)
        row = ""
        for offset in range(0, matrix_words * 4, 4):
            value = await self.wb_read(wb_matrix_start + offset)
            for bit_index in range(32):
                if value & bit(bit_index):
                    row += "*"
                else:
                    row += " "
                if len(row) == matrix_width and len(result) < matrix_height:
                    result.append(row)
                    row = ""
        return result


async def create_silife(dut):
    if hasattr(dut, 'VPWR'):
        # Running a gate-level simulation, connect the power and ground signals
        dut.VGND <= 0
        dut.VPWR <= 1

    wishbone = WishboneMaster(
        dut, "", dut.clk, width=32, timeout=10, signals_dict=wishbone_signals)
    silife = SiLifeController(dut, wishbone)
    return silife


@cocotb.test()
async def test_add(dut):
    silife = await create_silife(dut)
    clock_sig = await make_clock(dut, 10)
    await reset(dut)

    # Disable the Game of Life
    await silife.wb_write(reg_ctrl, 0)

    # Write a matrix with some initial state
    await silife.wb_write(wb_matrix_start, 0x00440055)
    await silife.wb_write(wb_matrix_start + 4, 0x10006678)

    # Assert that we read the same state back
    assert await silife.wb_read(wb_matrix_start) == 0x00440055
    assert await silife.wb_read(wb_matrix_start + 4) == 0x10006678

    # Now load a block with two blinkers
    await silife.write_matrix([
        "        ",
        " ***    ",
        "        ",
        "     *  ",
        "     *  ",
        "     *  ",
        "**      ",
        "**      ",
    ])

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
