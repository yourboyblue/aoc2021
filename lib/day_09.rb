# frozen_string_literal: true

class Day09
  include Enumerable

  def initialize
    @grid = File.readlines("09.txt").map { |line| line.scan(/\d/).map(&:to_i) }
    @w = @grid.first.length
    @h = @grid.length
  end

  def p1
    lows = select { |x, y| adj(x, y).all? { |x1, y1| val(x, y) < val(x1, y1) } }
    puts (lows.sum { |x, y| val(x, y) + 1 })
  end

  def p2
    tagged_points = {} # key = point, val = basin tag
    tag = 0
    unvisited = Set[*(map { |x, y| [x, y] })]

    while unvisited.any?
      tag += 1
      x, y = unvisited.to_a.first
      visit_adj(x, y, tag, unvisited, tagged_points)
    end
    
    three_largest_basins = tagged_points.values.tally.values.sort.last(3)

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
    @grid.each.with_index do |row, y|
      row.length.times do |x|
        yield [x, y]
      end
    end
  end

  # recursively visit adjacent points, tagging each with a common numeric identifier,
  # and marking each as visited
  def visit_adj(x, y, tag, unvisited, tagged_points)
    unvisited.delete([x, y])
    return if val(x, y) == 9

    adj(x, y).select { |x1, y1| unvisited.member?([x1, y1]) }.each do |x1, y1|
      unvisited.delete([x1, y1])
      next if val(x1, y1) == 9

      tagged_points[[x1, y1]] = tag
      visit_adj(x1, y1, tag, unvisited, tagged_points)
    end

    tagged_points[[x, y]] = tag
  end
end
