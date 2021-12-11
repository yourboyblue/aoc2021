# frozen_string_literal: true

require_relative "utils/grid"

class Day11
  def initialize
    grid_lines = File.readlines("11.txt").map { |line| line.scan(/\d/).map(&:to_i) }
    @g = Grid.new(grid_lines, diagonals_adjacent: true)
    @flash_count = 0
    @step_count = 0
    @octopus_count = @g.length
  end

  def p1
    100.times { step }
    puts @flash_count
  end

  def p2
    loop do
      found = step
      break if found
    end

    puts @step_count
  end

  def step
    @step_count += 1
    flashed = Set[]

    @g.each { |x, y| @g.set(x, y, @g.val(x, y) + 1) }
    to_flash = @g.select { |x, y| @g.val(x, y) > 9 }
    step_flash_count = to_flash.length

    while to_flash.any?
      new_to_flash = Set[]
      to_flash.each do |x, y|
        @g.adj(x, y).each do |x1, y1|
          unless flashed.include?([x1, y1])
            @g.set(x1, y1, @g.val(x1, y1) + 1)
            new_to_flash << [x1, y1] if @g.val(x1, y1) == 10
          end
        end
        @g.set(x, y, 0)
        flashed << [x, y]
        @flash_count += 1
      end
      step_flash_count += new_to_flash.length
      to_flash = new_to_flash.to_a
    end

    return true if step_flash_count == @octopus_count
  end
end
