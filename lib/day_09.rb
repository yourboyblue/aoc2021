# frozen_string_literal: true

require_relative 'utils/grid'

class Day09
  def initialize
    @g = Grid.new(File.readlines("09.txt").map { |line| line.scan(/\d/).map(&:to_i) })
  end

  def p1
    lows = @g.select { |x, y| @g.adj(x, y).all? { |x1, y1| @g.val(x, y) < @g.val(x1, y1) } }
    puts (lows.sum { |x, y| @g.val(x, y) + 1 })
  end

  def p2
    tagged_points = {} # key = point, val = basin tag
    tag = 0
    unvisited = Set[*(@g.map { |x, y| [x, y] })]

    while unvisited.any?
      tag += 1
      x, y = unvisited.to_a.first
      visit_adj(x, y, tag, unvisited, tagged_points)
    end
    
    three_largest_basins = tagged_points.values.tally.values.sort.last(3)

    puts three_largest_basins.reduce(:*)
  end

  # recursively visit adjacent points, tagging each with a common numeric identifier,
  # and marking each as visited
  def visit_adj(x, y, tag, unvisited, tagged_points)
    unvisited.delete([x, y])
    return if @g.val(x, y) == 9

    @g.adj(x, y).select { |x1, y1| unvisited.member?([x1, y1]) }.each do |x1, y1|
      unvisited.delete([x1, y1])
      next if @g.val(x1, y1) == 9

      tagged_points[[x1, y1]] = tag
      visit_adj(x1, y1, tag, unvisited, tagged_points)
    end

    tagged_points[[x, y]] = tag
  end
end
