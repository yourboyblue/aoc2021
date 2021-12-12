# frozen_string_literal: true

class Day12
  def initialize
    @caves = {}
    File.read("12.txt").split("\n").map { |line| line.split("-") }.each do |c1, c2|
      cave1 = (@caves[c1] ||= Cave.new(c1))
      cave2 = (@caves[c2] ||= Cave.new(c2))
      cave1 << cave2
      cave2 << cave1
    end
  end

  def p1
    paths = trace(double_small_allowed: false)
    puts "P1: #{paths.length}"
  end

  def p2
    paths = trace(double_small_allowed: true)
    puts "P2: #{paths.length}"
  end

  def trace(double_small_allowed:)
    exploring = [Path.new << @caves["start"]]
    completed = []

    while exploring.any?
      new_paths = []
      exploring.each do |p|
        p.last.connections.each do |cave|
          next if p.invalid?(cave, double_small_allowed: double_small_allowed)

          new_path = p.dup << cave
          if new_path.end?
            completed << new_path
          else
            new_paths << new_path
          end
        end
      end
      exploring = new_paths
    end

    completed
  end

  class Path
    def initialize(caves = [], visited = [], double_small: false)
      @visited = Set[*visited]
      @caves = [*caves]
      @double_small = double_small
    end

    def dup
      self.class.new(@caves, @visited, double_small: @double_small)
    end

    def invalid?(cave, double_small_allowed: false)
      return false unless cave.small?
      return false unless @visited.include?(cave)
      return true if cave.start?
      return true unless double_small_allowed

      @double_small
    end

    def <<(cave)
      @caves << cave
      @double_small = true if cave.small? && @visited.include?(cave)

      @visited << cave
      self
    end

    def last
      @caves.last
    end

    def end?
      last.end?
    end

    def length
      @caves.length
    end

    def to_s
      @caves.map(&:name).join("->")
    end
  end

  class Cave
    def initialize(name)
      @name = name
      @connections = []
    end

    attr_reader :name, :connections

    def small?
      @name.match?(/^[a-z]/)
    end

    def end?
      @name == "end"
    end

    def start?
      @name == "start"
    end

    def <<(child)
      @connections << child
      self
    end
  end
end

d = Day12.new
d.p1
d.p2
