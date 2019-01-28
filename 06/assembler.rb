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

class Parser
    attr_reader :line

    def initialize(line)
        @line = line
    end

    def pretty_print
        return print_a if a_instruction?
        print_c
    end

    private

    def a_instruction?
        line.include?('@')
    end

    def c_instruction?
        line.include?('=') || line.include?(';')
    end

    def print_a
        a = line.gsub("@", '')
        "0" + sprintf("%015b", a.to_i)
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
            formatted_line = line.gsub!("\n",'')
            stripped_line = formatted_line.split('//')[0].to_s
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

cleaned_text.each do |line|
    p = Parser.new(line)
    puts p.pretty_print
end

File.open(output_filename, 'w') do |file| 
    cleaned_text.each do |line|
        p = Parser.new(line)
        file.write(p.pretty_print + "\n")
    end
end


