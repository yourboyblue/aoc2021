class Day13
  def initialize
    lines = File.read("13.txt").split("\n")

    @coords = []
    @folds  = []
    lines.each do |line|
      next if line == ''
      if line.match?(/^fold/)
        md = line.match(/([xy])=(\d+)/)
        @folds << [md[1], md[2].to_i]
      else
        c = line.scan(/\d+/).map(&:to_i)
        @coords << c
      end
    end
  end

  def p1
    orientation, location = @folds.first
    coords = fold(@coords, orientation, location)
    puts coords.length
  end

  def p2
    coords = @coords
    @folds.each do |orientation, location|
      coords = fold(coords, orientation, location)
    end

    print_grid(coords)
  end

  def fold(coords, orientation, location)
    if orientation == 'y'
      below, above = coords.partition {|x,y| y > location }.map(&:to_set)

      below.each do |x, y|
        y1 = location - (y - location)
        above << [x, y1]
      end

      above
    else
      right, left = coords.partition {|x,y| x > location }.map(&:to_set)
      right.each do |x, y|
        x1 = location - (x - location)
        left << [x1, y]
      end

      left
    end
  end

  def print_grid(coords)
    mx = coords.map(&:first).max + 1
    my = coords.map(&:last  ).max + 1

    my.times do |y|
      mx.times do |x|
        p = coords.include?([x,y]) ? '#' : '.'
        print p.rjust(2, ' ')
      end
      puts
    end
  end
end

Day13.new.p1
Day13.new.p2
