class Day01
  def initialize
    @data = File.foreach('01.txt').map { |l| l.to_i }
  end

  def p2
    @data.each_cons(3).each_cons(2).count { |a, b| b.sum > a.sum }
  end

  def p1
    @data.each_cons(2).count { |a, b| b > a }
  end
end