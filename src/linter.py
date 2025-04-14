import argparse
import re

DEBUG=False

# TODO: tabs to spaces
# TODO: fix the constants at the top to align with all each other (keywords)
# TODO: comments should line up with the new move
# TODO: bits     32 looks weird
# TODO: single line comments look weird ; https://wiki.osdev.org/Protected_Mode

def get_indent_level(line_of_code):
    match = re.match(r"^(\t*)", line_of_code)
    return len(match.group(1)) if match else 0

def check_mixed_indentation(lines):
    for idx, line in enumerate(lines, 1):
        if re.match(r'^ +', line):
            print(f"Warning: Line {idx} starts with spaces.")
        elif re.match(r'^ *\t', line):
            print(f"Warning: Line {idx} has mixed spaces and tabs.")

def parse_instr(line, cmt_char=';'):
    s_line = line.strip()

    for word in ["equ", "%assign", "%define", "section", "bits", "org"]:
        if re.search(r'\b' + word + r'\b', s_line.lower()):
            code, _, cmt = s_line.partition(cmt_char)
            tokens = code.strip().split(None, 1)
            if not tokens:
                return ['k', '', '', '', cmt.strip()]
            keyword = tokens[0]
            ops = tokens[1] if len(tokens) > 1 else ''
            return ['k', '', keyword, ops, cmt.strip()]

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

def format_line(mnemonic, operands, cmt, col=40, indent=True):
    prefix = "\t" if indent else ""
    line = f"{prefix}{mnemonic:<8} {operands}".rstrip()
    if DEBUG and not indent:
        print(f"Current line {line}")
    if cmt:
        visual_len = len(line)
        padding = max(1, col - visual_len)
        line += ' ' * padding + f"; {cmt}"
    return line

def align_file(file_path, output_path=None, cmt_char=';', col=40):
    if file_path == output_path:
        user_choice = input(f"Do you want to overwrite: {file_path}? [Y/n] ")
        if user_choice.lower() not in ("y", ""):
            print("Skipping...")
            output_path = None

    with open(file_path, 'r') as f:
        lines = f.read().splitlines()
        if DEBUG:
            check_mixed_indentation(lines)

    blank_line = 0
    result_lines = []
    macro_buf = []

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
        elif typ == "k":
            # keyword_line = format_line(mnemonic, ops, cmt, col, indent=False)
            result_lines.append(line)
        elif typ == "c":
            result_lines.append(cmt)
        elif typ == "i":
            instr = format_line(mnemonic, ops, cmt, col, indent=True)
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
    parser.add_argument("-m", "--comment-char", default=";", help="Comment character (default: ;)")

    args = parser.parse_args()

    align_file(args.input, args.output, args.comment_char, args.col)

if __name__ == "__main__":
    main()

