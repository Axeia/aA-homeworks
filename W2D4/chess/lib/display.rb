require_relative 'board'
require_relative 'pieces/null_piece'
require 'colorize'
require_relative 'cursor'

class Display
    attr_reader :board, :notifications, :cursor

    def initialize(board)
        @board = board
        @cursor = Cursor.new([0, 0], board)
        @notifications = {}
    end

    def render
        system("clear")
        puts "Press ◄ ▲ ▼ ►, hjkl or WASD to move. Space or enter to confirm/select."
        board_render
    end

    def board_render
        output = ''
        c_v, c_h = @cursor.cursor_pos
        cursor_piece = @board[@cursor.cursor_pos]
        highlighted_squares = []
        unless cursor_piece.instance_of?(NullPiece)
            highlighted_squares = @board.rows[c_v][c_h].moves
        end

        @board.rows.each.with_index do |row, i|
            output += (8 - i).to_s + ' '
            row.each.with_index do |piece, j|
                field = ' ' + piece.to_s + '  '

                if highlighted_squares.include?([i,j])
                    field = highlight(field, checkered?(i,j))
                else #Not highlighted
                    if has_cursor?(i,j) && @cursor.selected
                        field = field.on_light_black
                    elsif has_cursor?(i,j)
                        field = field.on_light_blue
                    else
                        field = field.on_red if checkered?(i, j)
                    end
                end
                output += field
            end
            output += "\n"
        end

        output += '   ' + ('a'..'h').to_a.join('   ') + "\n"
        puts output
    end

    def highlight(field, checkered)
        checkered ? field.on_light_magenta : field.on_magenta
    end

    def checkered?(v, h)
        (v + h) % 2 == 0 
    end

    def has_cursor?(v, h)
        c_v, c_h = @cursor.cursor_pos
        v == c_v && h == c_h
    end

    def keep_rendering
        self.render
        while true 
            p cursor.get_input
            self.render
        end
    end
end

if __FILE__ == $0
    board = Board.new()
    display = Display.new(board)
    board.move_piece_str('f2, f3')
    board.move_piece_str('e7, e5')
    board.move_piece_str('g2, g4')
    board.move_piece_str('d8, h4')
    # display.keep_rendering
    display.render
    p board.in_check?(:white)
    p board.checkmate?(:white)
    # p board.checkmate?(:black)
    
end