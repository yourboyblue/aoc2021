class Day02
  def initialize
    @data = File.foreach('02.txt').map do |l| 
      cmd, num = l.split(' ')
      [cmd, num.to_i]
    end

    @depth = 0
    @h_pos = 0
    @aim   = 0
  end

  def p2
    @data.each do |cmd, num| 
      case cmd
      when 'forward'
        @h_pos += num
        @depth += @aim * num
      when 'up'
        @aim -= num
      when 'down'
        @aim += num
      end
    end

    puts @depth * @h_pos
  end

  def p1
    @data.each do |cmd, num| 
      case cmd
      when 'forward'
        @h_pos += num
      when 'up'
        @depth -= num
      when 'down'
        @depth += num
      end
    end

    puts @depth * @h_pos
  end
end