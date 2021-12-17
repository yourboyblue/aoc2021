# frozen_string_literal: true

require_relative "utils/grid"

class Day15
  def initialize
    grid_lines = File.readlines("15.txt").map { |line| line.scan(/\d/).map(&:to_i) }
    @g = Grid.new(grid_lines)
  end

  def p1
    path = a_star(@g.first, @g.last)
    puts path.sum { @g.val(*_1) } - @g.val(*@g.first)
  end

  def p2
    new_values = []
    # dup columns
    4.times do |i|
      @g.each_with_value do |x, y, v|
        new_v = v + 1 + i
        new_values << [x + (@g.w * (i + 1)), y, new_v > 9 ? new_v % 9 : new_v]
      end
    end

    new_values.each { |x, y, v| @g.set(x, y, v) }

    # dup rows
    new_values = []
    4.times do |i|
      @g.each_with_value do |x, y, v|
        new_v = v + 1 + i
        new_values << [x, y + (@g.h * (i + 1)), new_v > 9 ? new_v % 9 : new_v]
      end
    end

    @g.add_rows(@g.h * 4)
    new_values.each { |x, y, v| @g.set(x, y, v) }

    path = a_star(@g.first, @g.last)
    puts path.sum { @g.val(*_1) } - @g.val(*@g.first)
  end

  # half-assed A*
  def a_star(start, finish)
    open_set  = Set[start] # could be more efficient with priority queue
    came_from = {}
    g_score = { start => 0 }
    f_score = {}
    f_score[start] = @g.manhattan(*start, *finish)

    while open_set.any?
      current = open_set.min_by { f_score[_1] }
      return get_path(current, came_from) if current == finish

      open_set.delete(current)
      @g.adj(*current).each do |neighbor|
        tentative_g_score = g_score[current] + @g.val(*neighbor)
        next unless tentative_g_score < g_score.fetch(neighbor, 99_999_999_999_999)

        came_from[neighbor] = current
        g_score[neighbor] = tentative_g_score
        f_score[neighbor] = tentative_g_score + @g.manhattan(*neighbor, *finish)
        open_set << neighbor unless open_set.member?(neighbor)
      end
    end
  end

  def get_path(current, came_from)
    path = [current]
    while came_from.key?(current)
      current = came_from[current]
      path.prepend(current)
    end
    path
  end
end

Day15.new.p1
Day15.new.p2
