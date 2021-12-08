class Day08
  def p2
    output = File.readlines('08.txt').map do |line|
      signals, output = line.split('|')
      [signals, output].map { |arr| arr.scan(/[a-z]+/) }
    end

    puts output.sum { |signals, output| decode(signals, output) } 
  end

  def decode(signals, output)
    p = {}
    d2, d3, d4, d7 = nil

    signals.each do |sig|
      if sig.length == 2
        d2 = sig.chars
      elsif sig.length == 3
        d3 = sig.chars
      elsif sig.length == 4
        d4 = sig.chars
      elsif sig.length == 7
        d7 = sig.chars
      end 
    end

    # p1 is digit 7 minus digit 1 remainder
    p[1] = (d3 - d2).first
    
    # position 1 plus all of digit 4 subtracted from 6-segment digits gives position 7 when remainder is 1
    ptn   = [*d4,p[1]]
    sixes = signals.select { |s| s.length == 6 }
    p[7]  = sixes.map { |s| s.chars - ptn }.find { |a| a.length == 1 }.first

    # digit 8 minus ptn + p7 remainder is p5
    p[5] = (d7 - [*ptn, p[7]]).first

    ptn  = [p[1], p[5], p[7], *d2]
    p[2] = sixes.map { |s| s.chars - ptn }.find { |a| a.length == 1 }.first

    p[4] = (d4 - [*d2, p[2]]).first

    fives = signals.select { |s| s.length == 5 }
    ptn   = [p[1], p[2], p[4], p[7]]
    p[6]  = fives.map { |s| s.chars - ptn }.find { |a| a.length == 1 }.first

    p[3] = (d7 - [p[1],p[2],p[4],p[5],p[6],p[7]]).first

    digits = output.map do |sig|
      sorted = sig.chars.sort.join
      case sorted
      when to_re(p[3],p[6])                          then '1'
      when to_re(p[1],p[3],p[4],p[5],p[7])           then '2'
      when to_re(p[1],p[3],p[4],p[6],p[7])           then '3'
      when to_re(p[2],p[3],p[4],p[6])                then '4'
      when to_re(p[1],p[2],p[4],p[6],p[7])           then '5'
      when to_re(p[1],p[2],p[4],p[5],p[6],p[7])      then '6'
      when to_re(p[1],p[3],p[6])                     then '7'
      when to_re(p[1],p[2],p[3],p[4],p[5],p[6],p[7]) then '8'
      when to_re(p[1],p[2],p[3],p[4],p[6],p[7])      then '9'
      when to_re(p[1],p[2],p[3],p[5],p[6],p[7])      then '0'
      end
    end

    digits.join.to_i
  end

  def to_re(*letters)
    /^#{letters.sort.join}$/
  end

  def p1
    output = File.readlines('08.txt').flat_map do |line|
      line.split('|').last.scan(/[a-z]+/)
    end

    output.count do |digit|
      case digit.length
      when 2,3,4,7 then true
      else false
      end
    end
  end
end
