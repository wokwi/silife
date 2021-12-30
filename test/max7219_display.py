# SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
# SPDX-License-Identifier: MIT

"""
Simple MAX7219 Matrix Display
"""

import cocotb
from cocotb.triggers import First, RisingEdge


class MAX7219MatrixSegment:
    def __init__(self):
        self.data = [0] * 8
        self.brightness = 0
        self.scan_limit = 0
        self.decode_mode = 0
        self.enabled = False
        self.test_mode = True

    def write(self, reg, value):
        if reg >= 1 and reg <= 8:
            self.data[reg - 1] = value
        elif reg == 0x9:
            self.decode_mode = value
        elif reg == 0xA:
            self.brightness = value & 0xF
        elif reg == 0xB:
            self.scan_limit = value & 0x7
        elif reg == 0xC:
            self.enabled = bool(value & 0x1)
        elif reg == 0xF:
            self.test_mode = bool(value & 0x1)

    def dumpline(self, index):
        if self.test_mode:
            return "TESTTEST"
        if not self.enabled:
            return "xxxxxxxx"
        line = self.data[index]
        return "".join(("*" if line & (1 << b) else " " for b in range(8)))


class MAX7219MatrixDisplay:
    """32x32 MAX7219 Matrix Display (made out of four-by-four 8x8 segments)"""

    def __init__(self, cs, clk, data):
        self._clk = clk
        self._cs = cs
        self._data = data
        self._value = 0
        self._clk_count = 0
        self.segments = [MAX7219MatrixSegment() for _ in range(16)]
        cocotb.fork(self._clk_monitor())

    @cocotb.coroutine
    def _clk_monitor(self):
        self._clk_count = 0
        self._value = 0
        while True:
            if not self._cs.value:
                self._clk_count += 1
                self._value <<= 1
                self._value |= 1 if self._data.value else 0
                if self._clk_count % 16 == 0:
                    segment_index = 16 - self._clk_count // 16
                    if segment_index >= 0:
                        reg = self._value >> 8
                        data = self._value & 0xFF
                        self.segments[segment_index].write(reg, data)
                        self._value = 0
            else:
                self._clk_count = 0
                self._value = 0
            yield First(RisingEdge(self._clk), RisingEdge(self._cs))

    def dump(self):
        result = [""] * 32
        for row in range(4):
            for col in range(4):
                segment = self.segments[row * 4 + 3 - col]
                for line in range(8):
                    result[row * 8 + line] += segment.dumpline(line)
        return result
