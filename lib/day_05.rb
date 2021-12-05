class Day05
  def initialize
    @vents = File.foreach('05.txt').map { |l| l.scan(/\d+/).map(&:to_i) }
  end

  def p2
    puts @vents.flat_map { |vent| points_on_line(*vent) }.tally.count { |_, c| c > 1 }
  end

  def p1
    all_points = horizontal_or_vertical_vents.flat_map { |vent| points_on_line(*vent) }
    puts all_points.tally.count { |_, c| c > 1 }
  end

  def horizontal_or_vertical_vents
    @vents.select { |x1, y1, x2, y2| x1 == x2 || y1 == y2 }
  end

  def points_on_line(x1, y1, x2, y2)
    x_range  = range(x1, x2)
    y_range  = range(y1, y2)
    x_length = x_range.length
    y_length = y_range.length

    if x_length > y_length
      y_range = Array.new(x_length, y_range.first)
    elsif y_length > x_length
      x_range = Array.new(y_length, x_range.first)
    end

    x_range.zip(y_range)
  end

  def range(p1, p2)
    return [p1] if p1 == p2

    inc = p1 > p2 ? -1 : 1
    p = p1
    r = []
    while r.last != p2 do
      r << p 
      p += inc
    end

    r
  end
end