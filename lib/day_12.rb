# frozen_string_literal: true

class Day12
  def initialize
    edges = File.read("12.txt").split("\n").map { |line| line.split('-')}
    @caves = {}
    edges.each do |c1, c2|
      cave1 = (@caves[c1] ||= Cave.new(c1))
      cave2 = (@caves[c2] ||= Cave.new(c2))
      cave1 << cave2
      cave2 << cave1
    end
    @paths = []
  end

  def self.p1
    new.p1
  end

  def self.p2
    new.p2
  end

  def p1
    trace(double_small_allowed: false)
    puts "P1: #{@paths.length}"
  end

  def p2
    trace(double_small_allowed: true)
    puts "P2: #{@paths.length}"
  end

  def trace(double_small_allowed:)
    start = @caves['start']
    start_path = Path.new
    start_path << start
    @paths << start_path

    while !@paths.all?(&:end?)
      new_paths = []
      @paths.each do |p|
        if p.end?
          new_paths << p
          next
        end

        connections = p.last.connections
        connections.each do |cave|
          next if p.invalid?(cave, double_small_allowed: double_small_allowed)
          new_path = p.dup
          new_path << cave
          new_paths << new_path
        end
      end
      @paths = new_paths
    end
  end

  class Path
    def initialize(p = [], visited = [], double_small = false)
      @visited = Set[*visited]
      @p = [*p]
      @double_small = double_small
    end

    def dup
      self.class.new(@p, @visited, @double_small)
    end  

    def invalid?(cave, double_small_allowed: false)
      return false unless cave.small?
      return false unless @visited.include?(cave)
      return true if cave.start?
      return true unless double_small_allowed

      double_small?
    end

    def <<(cave)
      @p << cave
      @double_small = true if cave.small? && @visited.include?(cave)
        
      @visited << cave
      self
    end

    def double_small?
      @double_small
    end

    def last
      @p.last
    end

    def end?
      last.end?
    end

    def length
      @p.length
    end

    def to_s
      @p.map(&:name).join('->')
    end
  end

  class Cave
    def initialize(name)
      @name = name
      @connections = []
    end

    attr_reader :name

    def big?
      @name.match?(/^[A-Z]/)
    end

    def small?
      !big?
    end

    def end?
      @name == 'end'
    end

    def start?
      @name == 'start'
    end

    def <<(child)
      @connections << child
      self
    end

    def connections
      @connections
    end
  end
end

Day12.p1
Day12.p2
