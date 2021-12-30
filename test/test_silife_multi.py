# SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
# SPDX-License-Identifier: MIT

import os
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from .game_of_life import GameOfLife
from .mini_spi import MiniSPI


def bit(b):
    return 1 << b


# Grid configuration
grid_height = 32
grid_width = 32
test_generations = 50

# How many grid segments do we have?
grids_columns = 3
grids_rows = 2

# Wishbone bus registers
reg_ctrl = 0x3000_0000
REG_CTRL_EN = bit(0)
REG_CTRL_PULSE = bit(1)

reg_config = 0x3000_0004
REG_CONFIG_WRAP = bit(0)
REG_CONFIG_SYNC_EN_N = bit(4)
REG_CONFIG_SYNC_EN_E = bit(5)
REG_CONFIG_SYNC_EN_S = bit(6)
REG_CONFIG_SYNC_EN_W = bit(7)

reg_max7219_ctrl = 0x3000_0010
REG_MAX7219_EN = bit(0)
REG_MAX7219_PAUSE = bit(1)
REG_MAX7219_FRAME = bit(2)
REG_MAX7219_BUSY = bit(3)

reg_max7219_config = 0x3000_0014
REG_MAX7219_REVERSE_COLS = bit(0)
REG_MAX7219_SERPENTINE = bit(1)

reg_max7219_brightness = 0x3000_0018

BROADCAST_ADDR = 0x7FFF


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


class SiLifeMultiController:
    def __init__(self, dut):
        self._dut = dut
        self._loader_spi = MiniSPI(
            self._dut.clk,
            cs=getattr(self._dut, "i_load_cs$load"),
            clk=getattr(self._dut, "i_load_clk$load"),
            data=getattr(self._dut, "i_load_data$load"),
        )
        self._dut.i_sync_active.value = False
        self._dut.i_sync_clk.value = True

    async def init_spi_loader(self, unit_count=32, first_address=0):
        await self._loader_spi.start()
        await self._loader_spi.write(0xFFFFFFFF, bits=first_address + 1)
        await self._loader_spi.write(0, bits=unit_count)
        await self._loader_spi.end()

    async def spi_loader_write_reg(self, addr, value, unit_id=0):
        await self._loader_spi.start()
        await self._loader_spi.write(unit_id & 0x7FFF, bits=16)
        await self._loader_spi.write(0xFFFF, bits=16)
        await self._loader_spi.write(addr, bits=32)
        await self._loader_spi.write(value, bits=32)
        await self._loader_spi.end()

    async def spi_loader_write_multi(self, life):
        unit_id = 0
        for row in range(grids_rows):
            for col in range(grids_columns):
                await self._loader_spi.start()
                await self._loader_spi.write(unit_id & 0x7FFF, bits=16)
                await self._loader_spi.write(0, bits=16)  # row offset
                for y in range(grid_height):
                    value = 0
                    for x in range(grid_width):
                        if life.read_cell(row * grid_height + y, col * grid_width + x):
                            value |= bit(x)
                    await self._loader_spi.write(value, bits=grid_width)
                await self._loader_spi.end()
                unit_id += 1

    async def sync_cycle(self):
        self._dut.i_sync_active.value = True
        self._dut.i_sync_clk.value = False
        # Allow enough time for sync_busy to settle
        await ClockCycles(self._dut.clk, 1)
        while self._dut.o_busy.value:
            self._dut.i_sync_clk.value = True
            await ClockCycles(self._dut.clk, 1)
            self._dut.i_sync_clk.value = False
            await ClockCycles(self._dut.clk, 1)
        self._dut.i_sync_clk.value = True
        self._dut.i_sync_active.value = False
        await ClockCycles(self._dut.clk, 1)

    def dump_grid(self):
        self._dut.silife0_1.grid.cell_values.value
        result = [""] * (grids_rows * grid_height)
        for row in range(grids_rows):
            for col in range(grids_columns):
                unit = getattr(self._dut, "silife{}_{}".format(row, col))
                data = str(unit.grid.cell_values.value)
                data = data.replace("0", " ").replace("1", "*")
                for y in range(grid_height):
                    x_data = data[y * grid_width : (y + 1) * grid_width]
                    result[row * grid_height + grid_height - 1 - y] += x_data[::-1]
        return result


async def create_silife(dut):
    if hasattr(dut, "VPWR"):
        # Running a gate-level simulation, connect the power and ground signals
        dut.VGND <= 0
        dut.VPWR <= 1

    silife = SiLifeMultiController(dut)
    return silife


@cocotb.test()
async def test_multi_life(dut):
    silife = await create_silife(dut)
    clock_sig = await make_clock(dut, 10)
    await reset(dut)

    await silife.init_spi_loader()

    life = GameOfLife(
        height=grid_height * grids_rows, width=grid_width * grids_columns, wrap=False
    )

    # Add a filler pattern
    life.load(
        [
            "                     ***   ***                     ",
            "                    *  *   *  *                    ",
            " ****                  *   *                  **** ",
            " *   *                 *   *                 *   * ",
            " *        *            *   *            *        * ",
            "  *  *  **  *                         *  **  *  *  ",
            "       *     *       ***   ***       *     *       ",
            "       *     *        *     *        *     *       ",
            "       *     *        *******        *     *       ",
            "  *  *  **  *  **    *       *    **  *  **  *  *  ",
            " *        *   **    ***********    **   *        * ",
            " *   *         **                 **         *   * ",
            " ****           *******************           **** ",
            "                 * *           * *                 ",
            "                    ***********                    ",
            "                    *         *                    ",
            "                     *********                     ",
            "                         *                         ",
            "                     ***   ***                     ",
            "                       *   *                       ",
            "                                                   ",
            "                      *** ***                      ",
            "                      *** ***                      ",
            "                     * ** ** *                     ",
            "                     ***   ***                     ",
            "                      *     *                      ",
        ],
        pos=(3, 5),
    )

    print("Initial grid:")
    print("[" + "]\n[".join(life.dump()) + "]")

    # Load initial grid state
    await silife.spi_loader_write_multi(life)

    # Enable grid syncronization
    config = (
        REG_CONFIG_SYNC_EN_N
        | REG_CONFIG_SYNC_EN_E
        | REG_CONFIG_SYNC_EN_S
        | REG_CONFIG_SYNC_EN_W
    )
    await silife.spi_loader_write_reg(reg_config, config, unit_id=BROADCAST_ADDR)

    # Run grid for many generations
    for i in range(test_generations):
        print("Generation {} of {}...".format(i + 1, test_generations))
        await silife.sync_cycle()
        life.step()
        assert life.dump() == silife.dump_grid()
        print("[" + "]\n[".join(silife.dump_grid()) + "]")

    clock_sig.kill()
