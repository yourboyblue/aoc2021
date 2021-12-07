class Day07
  def initialize
    @crabs = File.read('07.txt').split(',').map(&:to_i)
    @positions = (@crabs.min..@crabs.max).to_a
  end

  def p2
    puts @positions.map { |pos| positional_alignment_cost_2(pos) }.min
  end

  def p1
    puts @positions.map { |pos| positional_alignment_cost(pos) }.min
  end

  def positional_alignment_cost(pos)
    @crabs.sum { |crab| (pos - crab).abs }
  end

  def positional_alignment_cost_2(pos)
    @crabs.sum { |crab| (1..(pos - crab).abs).sum }
  end
end
