order = 8

print("#N")
print("i_nw")
for i in range(order):
    print("cells\\[{}]".format(i))
    print("cells2\\[{}]".format(i))
    print("o_n\\[{}]".format(i))
    print("i_n\\[{}]".format(i))
print("i_ne")

print("#S")
print("i_sw")
for i in range(order):
    print("clear_cells\\[{}]".format(i))
    print("set_cells\\[{}]".format(i))
    print("i_s\\[{}]".format(i))
    print("o_s\\[{}]".format(i))
print("i_se")

print("#E")
for i in range(order, 0, -1):
    print("i_e\\[{}]".format(i - 1))
    print("o_e\\[{}]".format(i - 1))

print("#W")
print("reset")
print("clk")
print("enable")
for i in range(order, 0, -1):
    print("o_w\\[{}]".format(i - 1))
    print("i_w\\[{}]".format(i - 1))
print("row_select.*")
