import argparse

parser = argparse.ArgumentParser()
parser.add_argument("vcdfile")
parser.add_argument("--comments", action='store_true')
parser.add_argument("--timestamps", action='store_true')
args = parser.parse_args()

filter_vars = ["spi_cs", "spi_sck", "spi_mosi", "max7219_busy"]
filter_var_ids = {}


def pin_names(pin_values):
    result = []
    for index, var_name in enumerate(filter_vars):
        if pin_values & (1 << index):
            result.append(var_name)
    return ",".join(result)


def print_entry(value, comment):
    print("  {},{}".format(value, " " + comment if args.comments else ""))


def print_delay():
    global current_time, last_time
    if args.timestamps:
        print_entry(current_time - last_time, "/* ts: {} */".format(current_time))


def print_pins():
    global pin_values
    print_entry(pin_values, "/* pins: {} */".format(pin_names(pin_values)))


for index, var in enumerate(filter_vars):
    print("#define PIN_{} (0x{:02x})".format(var.upper(), 1 << index))
print("")
print("const uint32_t vcd_pin_data [] = {")


definition_section = True
last_time = 0
current_time = 0
pin_values = 0
for line in open(args.vcdfile):
    line = line.strip()
    parts = line.split(" ")
    if line.startswith("$var"):
        var_id = parts[3]
        var_name = parts[4]
        if var_name in filter_vars:
            filter_var_ids[var_id] = var_name
    if line.startswith("#"):
        current_time = int(line[1:]) // 1000  # convert to ns
    elif line[0] in "01xz":
        var_id = line.split(" ")[0][1:]
        if not (var_id in filter_var_ids):
            continue
        if current_time != last_time:
            print_delay()
            print_pins()
            last_time = current_time
        var_id = line[1]
        pin_index = filter_vars.index(filter_var_ids[var_id])
        if line[0] == "1":
            pin_values |= 1 << pin_index
        else:
            pin_values &= ~(1 << pin_index)

if current_time != last_time:
    print_delay()
    print_pins()

print("};")
