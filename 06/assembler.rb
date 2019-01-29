require 'pry'

C_TABLE = {
    "0" => "0101010",
    "1" => "0111111",
    "-1" => "0111010",
    "D" => "0001100",
    "A" => "0110000",
    "!D" => "0001101",
    "!A" => "0110001",
    "-D" => "0001111",
    "-A" => "0110011",
    "D+1" => "0011111",
    "A+1" => "0110111",
    "D-1" => "0001110",
    "A-1" => "0110010",
    "D+A" => "0000010",
    "D-A" => "0010011",
    "A-D" => "0000111",
    "D&A" => "0000000",
    "D|A" => "0010101",
    "M" => "1110000",
    "!M" => "1110001",
    "-M" => "1110011",
    "M+1" => "1110111",
    "M-1" => "1110010",
    "D+M" => "1000010",
    "D-M" => "1010011",
    "M-D" => "1000111",
    "D&M" => "1000000",
    "D|M" => "1010101"
}

DEST_TABLE = {
    "null" => "000",
    "M" => "001",
    "D" => "010",
    "MD" => "011",
    "A" => "100",
    "AM" => "101",
    "AD" => "110",
    "AMD" => "111"
}

JUMP_TABLE = {
    "null" => "000",
    "JGT" => "001",
    "JEQ" => "010",
    "JGE" => "011",
    "JLT" => "100",
    "JNE" => "101",
    "JLE" => "110",
    "JMP" => "111"
}

$symbol_table = {
    "R0" => "0",
    "R1" => "1",
    "R2" => "2",
    "R3" => "3",
    "R4" => "4",
    "R5" => "5",
    "R6" => "6",
    "R7" => "7",
    "R8" => "8",
    "R9" => "9",
    "R10" => "10",
    "R11" => "11",
    "R12" => "12",
    "R13" => "13",
    "R14" => "14",
    "R15" => "15",
    "SCREEN" => "16384",
    "KBD" => "24576",
    "SP" => "0",
    "LCL" => "1",
    "ARG" => "2",
    "THIS" => "3",
    "THAT" => "4"
}

class Parser
    attr_reader :line

    def initialize(line)
        @line = line
    end

    def pretty_print
        return print_a if a_instruction?
        print_c
    end

    def a_instruction?
        line.include?('@')
    end

    def j_instruction?
        line.chars.first == '(' && line.chars.last == ')'
    end

    def loop(string)
        /\(([^()]+)\)/.match(string)[1]
    end

    def a_value(string)
        string.gsub("@", '')
    end

    private

    def print_a
        a = a_value(line)
        value = $symbol_table[a].nil? ? a : $symbol_table[a]

        "0" + sprintf("%015b", value.to_i)
    end

    def print_c
        "111" + comp_bits + dest_bits + jump_bits
    end

    def comp_bits
        command = ''
        if line.include?('=')
            command = line.split('=').last
        else
            command = line.partition(';').first
        end
        C_TABLE.fetch(command)
    end

    def dest_bits
        return DEST_TABLE.fetch("null") if !line.include?('=')
        dest = line.split('=').first
        DEST_TABLE.fetch(dest)
    end

    def jump_bits
        jump = line.partition(';').last
        return JUMP_TABLE["null"] if jump.empty?
        JUMP_TABLE[jump]
    end
end

# Cleaner removes whitespace and comments returning a sequential list of the file's lines
class Cleaner
    def self.call(filepath)
        text = []
        File.readlines(filepath).each do |line|
            line.gsub!("\n",'')
            line.gsub!(' ','')
            stripped_line = line.split('//')[0].to_s

            text << stripped_line if !stripped_line.empty?
        end
        text
    end
end

input_array = ARGV

cleaned_text = Cleaner.call(ARGV[0])

filename = ARGV[0].split('/').last
output_filename = filename.partition('.')[0] + ".hack"

puts cleaned_text
puts filename
puts output_filename

# Add commands to symbol table
cleaned_text.each_with_index.map do |line, i|
    p = Parser.new(line)
    text = p.a_value(line)

    if p.j_instruction?
        text = p.loop(line)
        $symbol_table[text] = i
        cleaned_text.delete_at(i)
    end

    if p.a_instruction? && text.scan(/\d/).empty? && !$symbol_table.include?(text)
        $symbol_table[text] = 16 + i
    end
end

File.open(output_filename, 'w') do |file| 
    cleaned_text.each do |line|
        p = Parser.new(line)
        file.write(p.pretty_print + "\n")
    end
end


