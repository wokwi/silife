filter_vars = ["spi_cs", "spi_mosi", "spi_sck"]
filter_var_ids = []

print(
    """$date Mon Dec 20 15:22:00 2021 $end
$version Wokwi $end
$timescale 1ns $end"""
)

definition_section = True
for line in open("max7219_tb.vcd"):
    line = line.strip()
    parts = line.split(" ")
    if line.startswith("$var"):
        var_id = parts[3]
        var_name = parts[4]
        if var_name in filter_vars:
            filter_var_ids.append(var_id)
            print(line)
    if line.startswith("$enddefinitions"):
        definition_section = False
    if not definition_section:
        if line.startswith("$"):
            print(line)
        elif line.startswith("#"):
            print("#{}".format(int(line[1:]) // 1000))  # convert to ns
        elif line[0] in "01xz":
            var_id = line.split(" ")[0][1:]
            if var_id in filter_var_ids:
                print(line)

print("$enddefinitions $end")
