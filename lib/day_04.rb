require 'pry'

class Day04
  def initialize
    lines = File.read('04b.txt').split("\n")
    
    @numbers = lines.shift.split(',').map(&:to_i)
    
    @boards = lines.each_slice(6).map do |board_lines|
      board_lines.shift
      Board.new(board_lines.map { |line| line.scan(/\d+/).map(&:to_i) })
    end
  end

  def p2
    winning_boards = []
    num = nil
    
    while @boards.any? do
      num = @numbers.shift
      winners_for_round = @boards.select { |board| board.winner?(num) }
      
      if winners_for_round.any?
        winning_boards += winners_for_round
        @boards -= winners_for_round
      end 
    end

    puts num.to_i * winning_boards.last.score
  end

  def p1
    winning_board = nil
    num = nil
    
    while !winning_board do
      num = @numbers.shift
      winning_board = @boards.find { |board| board.winner?(num) } 
    end

    puts num.to_i * winning_board.score
  end

  class Board
    attr_reader :lines

    def initialize(rows)
      @rows = rows
      @lines = rows.map { |row| Line.new(row) }

      5.times do |i|
        col = rows.map { |row| row[i] }
        @lines << Line.new(col)
      end
    end

    def winner?(num)
      @lines.each { _1.mark(num) }
      @lines.any?(&:winner?)
    end

    def score
      @lines.map(&:unmarked).reduce(:+).reduce(:+)
    end
  end

  class Line
    def initialize(line)
      @line   = Set[*line]
      @marked = Set[]
    end

    def mark(num)
      @marked << num
    end

    def unmarked
      @line - @marked
    end

    def winner?
      @line <= @marked
    end
  end
end
