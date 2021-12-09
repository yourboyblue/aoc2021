# frozen_string_literal: true

class Day09
  include Enumerable

  def initialize
    @grid = File.readlines("09.txt").map { |line| line.scan(/\d/).map(&:to_i) }
    @w = @grid.first.length
    @h = @grid.length

    # vars for part 2
    @tagged_points = {} # key = point, val = basin tag
    @current_tag = 0
    @unvisited = Set[*(map { |x, y| [x, y] })]
  end

  def p1
    puts (lows.sum { |x, y| val(x, y) + 1 })
  end

  def p2
    puts three_largest_basins.reduce(:*)
  end

  def adj(x, y)
    [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].reject do |x1, y1|
      x1.negative? || y1.negative? || x1 >= @w || y1 >= @h
    end
  end

  def val(x, y)
    @grid[y][x]
  end

  def each
    @grid.each.with_index do |y, yi|
      y.each.with_index do |_x, xi|
        yield [xi, yi]
      end
    end
  end

  def lows
    select { |x, y| adj(x, y).all? { |x1, y1| val(x, y) < val(x1, y1) } }
  end

  def three_largest_basins
    map_basins!
    
    @tagged_points.values.tally.values.sort.last(3)
  end

  def map_basins!
    while @unvisited.any?
      @current_tag += 1
      x, y = @unvisited.to_a.first
      visit_adj(x, y)
    end
  end

  # recursively visit adjacent points, tagging each with a common numeric identifier,
  # and marking each as visited
  def visit_adj(x, y)
    @unvisited.delete([x, y])
    return if val(x, y) == 9

    adj_unvisited(x, y).each do |x1, y1|
      @unvisited.delete([x1, y1])
      next if val(x1, y1) == 9

      @tagged_points[[x1, y1]] = @current_tag
      visit_adj(x1, y1)
    end

    @tagged_points[[x, y]] = @current_tag
  end

  def adj_unvisited(x, y)
    adj(x, y).select { |x1, y1| @unvisited.member?([x1, y1]) }
  end
end
