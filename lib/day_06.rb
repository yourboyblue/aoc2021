class Day06
  def initialize
    @data = File.read('06.txt').split(',').map(&:to_i)
  end

  def p2
    LanternfishSchool.new(@data).age(256).count
  end

  def p1
    LanternfishSchool.new(@data).age(80).count
  end
  
  class LanternfishSchool
    def initialize(fishes)
      @school = Array.new(9, 0)
      fishes.each { |age| @school[age] += 1 }
    end

    def age(days)
      days.times do
        @school[7] += @school[0]
        spawn = @school.shift
        @school << spawn
      end
      self
    end

    def count
      @school.sum
    end
  end
end