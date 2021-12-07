class Day07
  def initialize
    @data = File.read('07.txt').split(',').map(&:to_i)
    @positions = (@data.min..@data.max).to_a
  end

  def p2
    puts @positions.map { |num| total_2(num) }.min
  end

  def p1
    puts @positions.map { |num| total(num) }.min
  end

  def total(num)
    @data.sum { |pos| (num - pos).abs }
  end

  def total_2(num)
    @data.sum { |pos| (1..(num - pos).abs).sum }
  end
end
