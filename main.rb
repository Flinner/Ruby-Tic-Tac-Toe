# frozen_string_literal: true

module Input
  # gets an integer between `start` and `ending`
  # 'Q' or 'q' `exit`s if `quitable` is set to `true`
  # Return `Integer` on success, `nil` otherwise
  #
  # @param start [Integer]
  # @param ending [Integer]
  # @param quitable [Boolean]
  # @return [Integer]
  def get_i_between(start, ending, quitable = true)
    input = gets.chomp
    exit_with_message if quitable && %w[q Q].include?(input)

    # check if input is of type Integer
    number = begin
      Integer(input)
    rescue StandardError
      return nil
    end

    # check range
    return number if start <= number && number <= ending
  end

  private

  def exit_with_message
    puts 'Exiting!'
    exit
  end
end

# Doc here // TODO!
class Game
  include Input

  def initialize
    # This is a `Game` Board.
    # that is composed of 3x3 matrix
    # it can only have one of the following values
    # `''`, `'X'`, `'O'`
    # @type [Array<Array<String>>]
    @board = [[nil, nil, nil],
              [nil, nil, nil],
              [nil, nil, nil]]
    # Can be 0 or 1
    # 0 = `O`
    # 1 = `X`
    @current_turn = 0
    @marks = { 0 => 'O', 1 => 'X' }
  end

  def play
    print_board false
    puts "You are player #{@current_turn + 1}"
    puts "Where do you want to place \"#{current_mark}\"?"
    p a = get_i_between(0, 2)
  end

  # `x` and `y` can only be in range 0 <= `x` or `y` <=2
  # Returns `true` if the play was sucessful, otherwise false
  # @param x [Integer]
  # @param y [Integer]
  # @return [Boolean]
  def place_mark(x, y)
    # place mark unsuccessful
    return begin puts "You can't choose that tile!"; false end unless @board[y][x].nil?

    @board[y][x] = current_mark
    next_turn
    true
  end

  def next_turn
    @current_turn = @current_turn.zero? ? 1 : 0
  end

  # @return [String]
  def current_mark
    @marks[@current_turn]
  end

  # @return [Boolean]
  def game_over?
    winning_rows? ||
      winning_columns? ||
      winning_diagonals? ||
      board_full?
  end

  # Print the board formatted
  # clears terminal when is `clear` =  `true`,
  # clear defaults to `true`
  # @param clear [Boolean]
  def print_board(clear = true)
    print "\033[2J\033[H" if clear
    p @board
  end

  private

  # @return [Boolean]
  def winning_rows?
    @board.any? do |row|
      # all elements are equal and no nils?
      !row[0].nil? &&
        row.uniq.size == 1
    end
  end

  # @return [Boolean]
  def winning_columns?
    # transpose to use same algorithm as `winning_rows?`
    @board.transpose.any? do |row|
      # all elements are equal and no nils?
      !row[0].nil? &&
        row.uniq.size == 1
    end
  end

  # @return [Boolean]
  def winning_diagonals?
    false
  end

  # @return [Boolean]
  def board_full?
    @board.all? do |row|
      !row.include? nil
    end
  end
end

def main
  puts 'Starting a new game!'
  game = Game.new

  game.play until game.game_over?

  puts "The winner is #{game}."
end

main

a = Game.new

p a.place_mark(1, 2)
p a.place_mark(1, 2)
