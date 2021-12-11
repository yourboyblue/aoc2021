# frozen_string_literal: true

class Grid
  include Enumerable

  def initialize(grid, diagonals_adjacent: false)
    @grid = grid
    @w = @grid.first.length
    @h = @grid.length
    @diagonals_adjacent = diagonals_adjacent
  end

  def val(x, y)
    @grid[y][x]
  end

  def set(x, y, v)
    @grid[y][x] = v
  end

  def length
    @grid.sum(&:length)
  end

  def each
    @grid.each.with_index do |row, y|
      row.length.times do |x|
        yield [x, y]
      end
    end
  end

  def adj(x, y)
    pts = [
      [x + 1, y],
      [x, y - 1],
      [x, y + 1],
      [x - 1, y]
    ]

    if @diagonals_adjacent
      pts += [
        [x + 1, y + 1],
        [x + 1, y - 1],
        [x - 1, y + 1],
        [x - 1, y - 1]
      ]
    end

    pts.reject do |x1, y1|
      x1.negative? || y1.negative? || x1 >= @w || y1 >= @h
    end
  end

  # @example default with no transformation
  #   grid.print
  #
  # @example with transformed values
  #   grid.print { |n| n.to_s.rjust(2, " ") }
  def print
    p = @grid.map do |row| 
      row.map do |val| 
        if block_given?
          yield val
        else
          val
        end
      end.join
    end.join("\n")

    puts p
  end
end
