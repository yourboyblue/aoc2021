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
      [x - 1, y], 
    ]

    pts += [
      [x + 1, y + 1], 
      [x + 1, y - 1], 
      [x - 1, y + 1], 
      [x - 1, y - 1], 
    ] if @diagonals_adjacent

    pts.reject do |x1, y1|
      x1.negative? || y1.negative? || x1 >= @w || y1 >= @h
    end
  end

  def print
    puts @grid.map { |row| row.map { |n| (n == 10 ? '0' : n.to_s).rjust(2,' ') }.join }.join("\n")
  end
end
