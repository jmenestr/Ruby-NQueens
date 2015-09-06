require 'colorize'
require 'set'
require 'benchmark'

class NQueens

  def initialize(n = 8)
    @n = n
    @board = Array.new(n) { Array.new(n)  }
    @solutions = []
    @queens = {}
    @unsafe_pos = Set.new
  end

  attr_reader :n, :solutions

  def solve(row = 0)
    if row >= n
      @solutions << dup
      return 
    end
      (0..(n-1)).each do |col|
      if is_safe?([row, col])
        place_queen([row, col])
        solve(row + 1)
        remove_queen([row, col])
      end
    end
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @board[row][col] = val
  end

  def print_solutions
    p @solutions.length
    @solutions.each do |solution|
      print render(solution)
      print "****"*n + "\n"
    end
  end

  private

  def is_safe?(pos)
    !@unsafe_pos.include?(pos)
  end


  def place_queen(pos)
    @queens[pos] = attack_positions(pos)
    update_unsafe
  end

  def remove_queen(pos)
    @queens.delete(pos)
    update_unsafe
  end

  def dup
    new_board = Array.new(n) { Array.new(n) { "   " } }
    @queens.keys.each do |quen_pos| 
      row, pos = quen_pos
      new_board[row][pos] = " Q ".colorize(:red) 
    end
    new_board
  end

  def render(solution)
    col_sep = "|".colorize(:blue)
    row_sep = ("----" * n + "\n").colorize(:blue)
    output = []
    solution.each do |row|
      output << [row.join(col_sep) + "\n"]
      output << [row_sep]
    end
    output.join
  end

  def update_unsafe
    @unsafe_pos = Set.new(@queens.values.flatten(1))
  end


  def attack_positions(position)
    attack = []
    delta = [
      [0,-1],
      [-1,-1],
      [-1,0],
      [-1,1],
      [0,1],
      [1,1],
      [1,0],
      [1,-1]
    ]

    delta.each do |dir|
      next_space = add_pos(dir, position)
      while in_bounds?(next_space)
        attack << next_space
        next_space = add_pos(dir, next_space)
      end
    end
    attack
  end

  def in_bounds?(position)
    row, col = position
    (0..(n-1)).include?(row) && (0..(n-1)).include?(col)
  end

  def add_pos(pos1, pos2)
    [pos1[0] + pos2[0], pos1[1] + pos2[1]]
  end

end






