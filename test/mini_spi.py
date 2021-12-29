# SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
# SPDX-License-Identifier: MIT

from cocotb.triggers import ClockCycles


class MiniSPI:
    def __init__(self, dut_clk, cs, clk, data):
        self._dut_clk = dut_clk
        self._cs = cs
        self._clk = clk
        self._data = data
        cs.value = True
        clk.value = False
        data.value = False

    async def start(self):
        self._cs.value = False
        self._clk.value = False
        await ClockCycles(self._dut_clk, 1)

    async def write(self, value, bits=32):
        """writes the given value, MSB-first"""
        for b in reversed(range(bits)):
            self._clk.value = False
            self._data.value = bool(value & (1 << b))
            await ClockCycles(self._dut_clk, 1)
            self._clk.value = True
            await ClockCycles(self._dut_clk, 1)
        self._clk.value = False

    async def end(self):
        self._cs.value = True
        self._clk.value = False
        await ClockCycles(self._dut_clk, 1)
