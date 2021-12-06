class Day06
  def initialize
    @data = File.read('06.txt').split(',').map(&:to_i)
  end

  def p2
    fishes = Array.new(9, 0) 
    @data.each { |day| fishes[day] += 1 }

    256.times do
      age_one_day(fishes)
    end

    puts fishes.sum
  end

  def p1
    fishes = Array.new(9, 0) 
    @data.each { |day| fishes[day] += 1 }

    80.times do
      age_one_day(fishes)
    end

    puts fishes.sum
  end
  
  def age_one_day(fishes)
    fishes[7] += fishes[0]
    spawn = fishes.shift
    fishes << spawn
  end
end