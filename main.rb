# frozen_string_literal: true

# this is atest
class Game
  def initialize
    # This is a `Game` Board.
    # that is composed of 3x3 matrix
    # it can only have one of the following values
    # `''`, `'X'`, `'O'`
    # @type [Array<Array<String>>]
    @board = [['', '', ''],
              ['', '', ''],
              ['', '', '']]
    # Can be 0 or 1
    # 0 = `O`
    # 1 = `X`
    @current_turn = 0
  end

  def play(x, y)
    return puts "You can't choose that tile!" unless @board[y][x].empty?

    @board[y][x] = current_letter
    next_turn
  end

  def next_turn
    @current_turn = @current_turn.zero? ? 1 : 0
  end

  # 0 = `O`
  # 1 = `X`
  def current_letter
    @current_turn.zero? ? 'X' : 'O'
  end

  def game_over?
    wining_rows? ||
      wining_columns? ||
      wining_diagonals? ||
      board_full?
  end

  private

  def wining_rows?; end

  def wining_columns?; end

  def wining_diagonals?; end

  def board_full?; end
end

a = Game.new

p a.play(1, 1)
p a.play(1, 1)
p a.play(1, 2)
