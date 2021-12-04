class Day03
  def initialize
    @data = File.read('03b.txt').split("\n")
    @digits = @data.first.length
  end

  def p2
    o2 =  find(tiebreak: '1')
    co2 = find(tiebreak: '0')

    puts o2.to_i(2) * co2.to_i(2)
  end

  def find(tiebreak:)
    list  = @data
    digit = 0

    while list.length > 1 do
      a, b = list.partition { |num| num.chars[digit] == '0' }

      list =  
        if a.length == b.length
          a.first[digit] == tiebreak ? a : b
        elsif tiebreak == '1'
          a.length > b.length ? a : b
        else 
          a.length > b.length ? b : a
        end

      digit += 1
    end

    list[0]
  end

  def p1
    gamma = ''
    epsilon = ''

    @digits.times do |i|
      ones  = 0
      zeros = 0

      @data.each { |n| n.chars[i] == '1' ? ones += 1 : zeros += 1 }

      if ones > zeros
        gamma << '1'
        epsilon << '0'
      else
        gamma << '0'
        epsilon << '1'
      end
    end

    puts gamma.to_i(2) * epsilon.to_i(2)
  end
end