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
        # print(f"{typ} {label} {instr} {ops} {cmt}")

        line = line.rstrip()

        #indent = get_ident_level(line)
        #print(f"{indent}: {line}")

        # if line.strip() == "":
        if typ == "b":
            blank_line += 1
            if blank_line <= 2:
                #aligned_lines.append("")
                result_lines.append("")
            continue
        else:
            blank_line = 0

        # if re.match(r"^\s*[\w.]+:$", line):
        if typ == "l":
            result_lines.append(label)
        #elif cmt_char in line:
        elif typ == "c":
            result_lines.append(cmt)
            #code, cmt = line.split(comment_char, 1)
            #code = code.rstrip()
            #spaces = ' ' * max(1, col - len(code))
            #aligned_line = f"{code}{spaces}{cmt_char} {comment.strip()}"
        elif typ == "i":
            instr = format_instr(menmonic, ops, cmt, col)
            result_lines.append(instr)
        #else:
        #    aligned_line = line.rstrip()
        # aligned_lines.append(aligned_line)


    while result_lines and result_lines[-1].strip() == '':
        result_lines.pop()
    result_lines.append('')

    #while len(lines) > 0 and lines[-1].strip() == "":
    #    lines.pop()
    #lines.append("")

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

