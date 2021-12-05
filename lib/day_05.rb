class Day05
  def initialize
    @vents = File.foreach('05.txt').map { |l| l.scan(/\d+/).map(&:to_i) }
  end

  def p2
    puts @vents.flat_map { points_on_line(*_1) }.tally.count { _2 > 1 }
  end

  def p1
    puts horizontal_or_vertical_vents.flat_map { points_on_line(*_1) }.tally.count { _2 > 1 }
  end

  def horizontal_or_vertical_vents
    @vents.select { |x1, y1, x2, y2| x1 == x2 || y1 == y2 }
  end

  def points_on_line(x1, y1, x2, y2)
    number_of_points = [(x1 - x2).abs + 1, (y1 - y2).abs + 1].max
    x_range = range(x1, x2, number_of_points)
    y_range = range(y1, y2, number_of_points)
    x_range.zip(y_range)
  end

  def range(p1, p2, number_of_points)
    if p1 == p2
      Array.new(number_of_points, p1)
    elsif p1 > p2
      [*p2..p1].reverse
    else
      [*p1..p2]
    end
  end
end