class Day10
  def initialize
    @lines = File.read("10.txt").split("\n").map { |l| Line.new(l.chars) }
  end

  def p1
    puts @lines.sum(&:score)
  end

  def p2
    scores = @lines.map(&:score_incomplete).compact
    puts scores.sort[scores.length / 2]
  end

  class Line
    PAIRS = { 
      '[' => ']',
      '{' => '}',
      '(' => ')',
      '<' => '>',
    }

    def initialize(chars)
      @chars = chars
      @open = []
      @invalid = nil
      scan!
    end

    def scan!
      @chars.each do |char|
        next @open << char if char.match?(/[\[\{\(\<]/)

        open_match = @open.pop
        next if PAIRS[open_match] == char

        @invalid = char
        break
      end
    end

    def score
      case @invalid
      when ')' then 3
      when ']' then 57
      when '}' then 1197
      when '>' then 25137
      else 
        0
      end
    end 

    def score_incomplete
      return unless @open.any? && !@invalid

      @open.reverse.reduce(0) { |sum, char| sum * 5 + score_end_match(char) }
    end

    def score_end_match(char)
      case PAIRS[char]
      when ')' then 1
      when ']' then 2
      when '}' then 3
      when '>' then 4
      end
    end
  end
end
