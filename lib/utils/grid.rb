# frozen_string_literal: true

class Grid
  include Enumerable

  def initialize(grid, diagonals_adjacent: false)
    @grid = grid
    @w = @grid.first.length
    @h = @grid.length
    @diagonals_adjacent = diagonals_adjacent
  end

  attr_reader :w, :h

  def val(x, y)
    @grid[y][x]
  end

  def set(x, y, v)
    @w = x + 1 if x >= @w
    @grid[y][x] = v
  end

  def length
    @grid.sum(&:length)
  end

  def manhattan(x, y, x1, y1)
    (x - x1).abs + (y - y1).abs
  end

  def each
    @grid.each.with_index do |row, y|
      row.length.times do |x|
        yield [x, y]
      end
    end
  end

  def dup
    g = Array.new(@h, [])
    each_with_value do |_x, y, v|
      g[y] << v
    end
    self.class.new(g)
  end

  def add_rows(n)
    n.times do
      @grid[@h] = []
      @h += 1
    end
  end

  def each_with_value
    @grid.each.with_index do |row, y|
      row.length.times do |x|
        yield [x, y, val(x, y)]
      end
    end
  end

  def first
    [0, 0]
  end

  def last
    [@w - 1, @h - 1]
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
