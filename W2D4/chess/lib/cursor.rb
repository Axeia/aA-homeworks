require "io/console"

KEYMAP = {
  " " =>      :space,
  "h" =>      :left,
  "j" =>      :down,
  "k" =>      :up,
  "l" =>      :right,
  "w" =>      :up,
  "a" =>      :left,
  "s" =>      :down,
  "d" =>      :right,
  "\t" =>     :tab,
  "\r" =>     :return,
  "\n" =>     :newline,
  "\e" =>     :escape,
  "\e[A" =>   :up,
  "\e[B" =>   :down,
  "\e[C" =>   :right,
  "\e[D" =>   :left,
  "\177" =>   :backspace,
  "\004" =>   :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left:   [0, -1],
  right:  [0, 1],
  up:     [-1, 0],
  down:   [1, 0]
}

class Cursor

  attr_reader   :cursor_pos, :board
  attr_writer   :cursor_pos
  attr_accessor :selected

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board
    @selected = false
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  private

  def read_char
    STDIN.echo = false # stops the console from printing return values

    STDIN.raw! # in raw mode data is given as is to the program--the system
                 # doesn't preprocess special characters such as control-c

    input = STDIN.getc.chr # STDIN.getc reads a one-character string as a
                             # numeric keycode. chr returns a string of the
                             # character represented by the keycode.
                             # (e.g. 65.chr => "A")

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil # read_nonblock(maxlen) reads
                                                   # at most maxlen bytes from a
                                                   # data stream; it's nonblocking,
                                                   # meaning the method executes
                                                   # asynchronously; it raises an
                                                   # error if no data is available,
                                                   # hence the need for rescue

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true # the console prints return values again
    STDIN.cooked! # the opposite of raw mode :)

    return input
  end
  # Fill in the #handle_key(key) method. 
  # Use a case statement that switches on the value of key. 
  # Depending on the key, #handle_key(key) will 
  # a) return the @cursor_pos (in case of :return or :space), 
  # b) call #update_pos with the appropriate movement difference from MOVES and return nil (in case of :left, :right, :up, and :down), or 
  # c) exit from the terminal process (in case of :ctrl_c). Later we will use our Player and Game classes to handle the movement of pieces.
  def handle_key(key)
    case key
    when :return, :space
      toggle_selected
      return @cursor_pos
    when :left, :right, :down, :up
      update_pos(MOVES[key])
      return nil
    when :ctrl_c
      Process.exit(0)
    else
      puts 'Unhandled: ' + key.to_s
    end
  end

  def toggle_selected
    @selected = !@selected
  end

  def update_pos(diff)
    v, h = diff
    c_v, c_h = @cursor_pos
    new_cursor_pos = [c_v + v, c_h + h] 
    @cursor_pos = new_cursor_pos if Board::valid_pos?(new_cursor_pos)
  end
end