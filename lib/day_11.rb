require 'set'

class Day11
  include Enumerable

  def initialize
    @grid = File.readlines("11.txt").map { |line| line.scan(/\d/).map(&:to_i) }
    @w = @grid.first.length
    @h = @grid.length
    @flash_count = 0
    @step_count = 0
    @o_count = reduce(0) { |acc,_| acc+1 }
  end

  def p1
    100.times { step }
    puts @flash_count
  end

  def p2
    loop do
      found = step
      break if found
    end

    puts @step_count
  end

  def step
    @step_count += 1
    flashed = Set[]

    each { |x, y| set(x, y, val(x, y) + 1) }
    to_flash = select { |x, y| val(x, y) > 9}
    fc = to_flash.length

    while to_flash.any? do
      new_to_flash = Set[]
      to_flash.each do |x, y|
        adj(x,y).each do |x1, y1|
          if !flashed.include?([x1,y1])
            set(x1,y1, val(x1,y1) + 1)
            new_to_flash << [x1,y1] if val(x1, y1) == 10
          end
        end
        set(x,y,0)
        flashed << [x,y]
        @flash_count += 1
      end
      fc += new_to_flash.length
      to_flash = new_to_flash.to_a
    end

    return true if fc == @o_count
  end

  def adj(x, y)
    neighbors = [
      [x, y - 1],
      [x, y + 1],
      [x + 1, y], 
      [x + 1, y + 1], 
      [x + 1, y - 1], 
      [x - 1, y], 
      [x - 1, y + 1], 
      [x - 1, y - 1], 
    ].reject do |x1, y1|
      x1.negative? || y1.negative? || x1 >= @w || y1 >= @h
    end
  end

  def print
    puts @grid.map { |row| row.map { |n| (n == 10 ? '0' : n.to_s).rjust(2,' ') }.join }.join("\n")
  end

  def val(x, y)
    @grid[y][x]
  end

  def set(x, y, v)
    @grid[y][x] = v
  end

  def each
    @grid.each.with_index do |row, y|
      row.length.times do |x|
        yield [x, y]
      end
    end
  end
end

