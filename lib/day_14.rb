# frozen_string_literal: true

class Day14
  def self.expand(iterations)
    poly, _, *rest = File.read("14.txt").split("\n")
    inserts = rest.map { _1.split(" -> ") }.to_h

    # count starting atoms and pairs
    atoms = poly.chars.tally
    pairs = poly.chars.each_cons(2).map { _1.join }.tally

    iterations.times do
      new_pairs = Hash.new { |h, k| h[k] = 0 }
      pairs.each do |pair, count|
        # each pair expands into two new pairs
        a, b = pair.chars
        m = inserts[pair]
        ["#{a}#{m}", "#{m}#{b}"].each { new_pairs[_1] += count }

        # each pair adds a new atom to the poly
        atoms[inserts[pair]] ||= 0
        atoms[inserts[pair]] += count
      end
      pairs = new_pairs
    end

    v = atoms.values
    puts v.max - v.min
  end
end

Day14.expand(10)
Day14.expand(40)
