import argparse
import re

def get_ident_level(line_of_code, tabsize=4):
    return len(re.match(r"^(\s*)", line_of_code.expandtabs(tabsize)).group(1))

def parse_instr(line, cmt_char=';'):
    s_line = line.strip()

    # TODO: ignore constants (equ, define, or assign)

    # blank line
    if not s_line: return ['b', '', '', '', '']

    # comment only
    if s_line.startswith(cmt_char): return ['c', '', '', '', line.rstrip()]

    # label
    if re.match(r"^[\w.]+:$", s_line): return ['l', line, '', '', '']

    code, _, cmt = s_line.partition(cmt_char)
    cmt = cmt.strip() if cmt else ''
    tokens = code.strip().split(None, 1)
    mnemonic = tokens[0] if tokens else ''
    ops = tokens[1] if len(tokens) > 1 else ''

    return ['i', '', mnemonic, ops, cmt]


def format_instr(mnemonic, operands, cmt, col=40):
    # <TAB><instr><padding><operand><cmt>
    line = f"\t{mnemonic:<8} {operands}".rstrip()
    if cmt:
        visual_len = len(line.expandtabs(4))
        padding = max(1, col - visual_len)
        line += ' ' * padding + f"; {cmt}"
    return line

def align_file(file_path, output_path=None, cmt_char=';', col=40):
    with open(file_path, 'r') as f:
        lines = f.readlines()

    blank_line = 0
    result_lines = []

    for line in lines:
        typ, label, mnemonic, ops, cmt = parse_instr(line, cmt_char)

        line = line.rstrip()

        if typ == "b":
            blank_line += 1
            if blank_line <= 2:
                result_lines.append("")
            continue
        else:
            blank_line = 0

        if typ == "l":
            result_lines.append(label)
        elif typ == "c":
            result_lines.append(cmt)
        elif typ == "i":
            instr = format_instr(mnemonic, ops, cmt, col)
            result_lines.append(instr)

    while result_lines and result_lines[-1].strip() == '':
        result_lines.pop()
    result_lines.append('')

    output = '\n'.join(result_lines) + '\n'

    if output_path:
        with open(output_path, 'w') as f:
            f.write(output)
    else:
        print(output)

def main():
    parser = argparse.ArgumentParser(description="Basic ASM Linter")
    parser.add_argument("input", help="Input file")
    parser.add_argument("-o", "--output", help="Output file (optional, default: stdout)")
    parser.add_argument("-c", "--col", type=int, default=40, help="Column to align comments to (default: 40)")
    parser.add_argument("-d", "--delim", default=";", help="cmt char (default: ;)")

    args = parser.parse_args()

    align_file(args.input, args.output, args.delim, args.col)

if __name__ == "__main__":
    main()

