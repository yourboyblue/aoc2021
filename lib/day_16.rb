class Day16
  class EndOfPacket < StandardError; end
  
  MAP = {
    "0" => "0000",
    "1" => "0001",
    "2" => "0010",
    "3" => "0011",
    "4" => "0100",
    "5" => "0101",
    "6" => "0110",
    "7" => "0111",
    "8" => "1000",
    "9" => "1001",
    "A" => "1010",
    "B" => "1011",
    "C" => "1100",
    "D" => "1101",
    "E" => "1110",
    "F" => "1111"
  }

  def initialize
    @hex = File.read('16.txt').chomp.chars
    @bin = ''
    @ptr = 0

    @packets = []
    @sum_versions = 0
  end

  def p1
    read_packets
    puts @sum_versions
  end

  def p2
    read_packets
    puts @packets.last.calculate_value
  end

  def read_packets
    loop do
      # squish subpackets 
      while @packets.last&.subpackets_found? && @packets.length > 1
        last = @packets.pop
        last.calculate_value

        if @packets.any?
          @packets.last.add_subpacket(last)
        else
          @packets << last 
        end
      end

      version = read(3).to_i(2)
      # sum the solution for P1
      @sum_versions += version 

      type = read(3).to_i(2)
      
      packet =
        if type == 4
          Packet.new(version, type, nil, 1).tap do |p|
            while !p.subpackets_found? do
              p.add_subpacket(read(5))
            end
          end
        else
          mode = (read(1).to_i(2) == 0 ? :length : :count)
          remaining = mode == :length ? read(15) : read(11)
          Packet.new(version, type, mode, remaining.to_i(2))
        end
      
      @packets << packet
    rescue IncompletePacket
      break
    end
  end

  def read(n)
    while unread < n do 
      decode
    end

    str = ''
    n.times do 
      str << @bin[@ptr]
      @ptr += 1
    end
    str
  end

  def decode
    @bin << MAP.fetch(@hex.shift) { raise IncompletePacket }
  end

  def unread
    @bin.length - @ptr
  end

  class Packet
    def initialize(version, type, mode, remaining)
      @version = version
      @type = type
      @mode = mode
      @remaining = remaining
      @length = initial_length
      @subpackets = []
      @value = nil
    end

    attr_reader :value, :version, :length, :subpackets

    def initial_length
      return 6 if @type == 4
      
      @mode == :length ? 22 : 18
    end

    def subpackets_found?
      @remaining == 0
    end

    def add_subpacket(packet)
      @subpackets << packet
      @length += packet.length
      if @type == 4
        @remaining -= 1 if packet.start_with?('0')
      elsif @mode == :length
        @remaining -= packet.length
      elsif @mode == :count
        @remaining -= 1
      end
    end

    def calculate_value
      subpacket_values = @type == 4 ? @subpackets : @subpackets.map(&:value)

      @value = 
        case @type
        when 0
          subpacket_values.sum
        when 1 
          subpacket_values.reduce(:*)
        when 2
          subpacket_values.min
        when 3
          subpacket_values.max
        when 4
          subpacket_values.map { _1.slice(1..-1) }.join.to_i(2)
        when 5
          subpacket_values[0] > subpacket_values[1] ? 1 : 0
        when 6
          subpacket_values[0] < subpacket_values[1] ? 1 : 0
        when 7
          subpacket_values[0] == subpacket_values[1] ? 1 : 0
        end
    end
  end
end

Day16.new.p1
Day16.new.p2

