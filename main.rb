# frozen_string_literal: true

# this is atest
class Game
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
  end

  def play(x, y)
    return puts "You can't choose that tile!" unless @board[y][x].nil?

    @board[y][x] = current_letter
    p "game over #{game_over?}"
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

  # @return [Boolean]
  def game_over?
    winning_rows? ||
      winning_columns? ||
      winning_diagonals? ||
      board_full?
  end

  private

  def winning_rows?
    @board.any? do |row|
      # all elements are equal and no nils?
      !row[0].nil? &&
        row.uniq.size == 1
    end
  end

  def winning_columns?
    # transpose to use same algorithm as `winning_rows?`
    @board.transpose.any? do |row|
      # all elements are equal and no nils?
      !row[0].nil? &&
        row.uniq.size == 1
    end
  end

  def winning_diagonals?
    false
  end

  def board_full?; end
end

a = Game.new
