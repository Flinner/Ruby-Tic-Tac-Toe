# frozen_string_literal: true

# Getting Input, heh
module Input
  # gets an integer between `start` and `ending`
  # 'Q' or 'q' `exit`s if `quitable` is set to `true`
  # prints error messages if `prints` is set to `true`
  # Return `Integer` on success, `nil` otherwise
  #
  # @param start [Integer]
  # @param ending [Integer]
  # @param quitable [Boolean]
  # @param prints [Boolean]
  # @return [Integer]
  def get_i_between(start, ending, quitable = true, prints = true)
    input = gets.chomp
    exit_with_message if quitable && %w[q Q].include?(input)

    # check if input is of type Integer
    number = begin
      Integer(input)
    rescue StandardError
      puts 'Input can only be an Integer!'.red if prints
      puts 'Try again!'.italic if prints
      return nil
    end

    # check range
    return number if start <= number && number <= ending

    # Error! not a number
    puts "Input can only be in range #{start} to #{ending}!".red if prints
    puts 'Try again!'.italic if prints
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

  def initialize(player_names = { 0 => '0', 1 => '1' })
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
    @player_names = player_names
  end

  def play
    print_board(clear = true)
    puts 'You are player: '.blue + current_player.to_s.blue.bold
    puts "Where do you want to place \"#{current_mark}\"?".bold
    puts 'Enter Column Number (between 0 and 2)'
    until x = get_i_between(0, 2); end
    puts 'Enter Row Number (between 0 and 2)'
    until y = get_i_between(0, 2); end

    # sleep on error, so that the message is readable!
    sleep 1 unless place_mark(x, y)
  end

  # `x` and `y` can only be in range 0 <= `x` or `y` <=2
  # Returns `true` if the play was sucessful, otherwise false
  # @param x [Integer]
  # @param y [Integer]
  # @return [Boolean]
  def place_mark(x, y)
    # place mark unsuccessful
    return begin puts "You can't choose that tile!".red; false end unless @board[y][x].nil?

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

  def current_player
    @player_names[@current_turn]
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
  # Board Shape
  # ```
  # ┌───┬───┬───┐
  # │ O │ X │ X │
  # ├───┼───┼───┤
  # │ O │ X │ X │
  # ├───┼───┼───┤
  # │ X │ X │ X │
  # └───┴───┴───┘
  # ```
  # @param clear [Boolean]
  def print_board(clear = true)
    print "\033[2J\033[H" if clear
    puts '┌───┬───┬───┐'

    @board.each_with_index do |row, index|
      printf("│ %1s │ %1s │ %1s │\n", row[0], row[1], row[2])
      # don't want to print this on last row
      puts '├───┼───┼───┤' if index != 2
    end
    puts '└───┴───┴───┘'
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
    !@board[1][1].nil? && ((
    @board[0][0] == @board[1][1] && @board[1][1] == @board[2][2]
  ) || (
    @board[2][0] == @board[1][1] && @board[1][1] == @board[2][0]
  ))
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
  puts 'Choose names!'.blue
  print 'Player 1> '.bold
  player1 = gets.chomp
  print 'Player 2> '.bold
  player2 = gets.chomp

  game = Game.new({ 0 => player1, 1 => player2 })

  game.play until game.game_over?
  # Print the board for the last time!
  game.print_board
  # switch to next turn so that current_player is set to the actual winner
  game.next_turn
  puts "The winner is #{game.current_player}."
end

# rubocop:disable all
# https://stackoverflow.com/questions/1489183/how-can-i-use-ruby-to-colorize-the-text-output-to-a-terminal
class String
def black;          "\e[30m#{self}\e[0m" end
def red;            "\e[31m#{self}\e[0m" end
def green;          "\e[32m#{self}\e[0m" end
def brown;          "\e[33m#{self}\e[0m" end
def blue;           "\e[34m#{self}\e[0m" end
def magenta;        "\e[35m#{self}\e[0m" end
def cyan;           "\e[36m#{self}\e[0m" end
def gray;           "\e[37m#{self}\e[0m" end

def bg_black;       "\e[40m#{self}\e[0m" end
def bg_red;         "\e[41m#{self}\e[0m" end
def bg_green;       "\e[42m#{self}\e[0m" end
def bg_brown;       "\e[43m#{self}\e[0m" end
def bg_blue;        "\e[44m#{self}\e[0m" end
def bg_magenta;     "\e[45m#{self}\e[0m" end
def bg_cyan;        "\e[46m#{self}\e[0m" end
def bg_gray;        "\e[47m#{self}\e[0m" end

def bold;           "\e[1m#{self}\e[22m" end
def italic;         "\e[3m#{self}\e[23m" end
def underline;      "\e[4m#{self}\e[24m" end
def blink;          "\e[5m#{self}\e[25m" end
def reverse_color;  "\e[7m#{self}\e[27m" end
end
# rubocop:enable all
main
