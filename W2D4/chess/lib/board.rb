require_relative 'piece'

class Board
    class NoPieceAtPosError < StandardError; end
    class InvalidEndPosError < StandardError; end

    def initialize
        @rows = Array.new(8){ Array.new(8) }
        set_up_board
    end

    def set_up_board
        @rows.each{ |cols| cols.each{ |c| c = nil } }
        [0, 1, 6, 7].each do |v| 
            (0..7).to_a.each{ |h| @rows[v][h] = Piece.new() }
        end
    end

    def move_piece(start_pos, end_pos)
        start_v, start_h = start_pos
        end_v, end_h     = end_pos
        
        piece = piece(start_pos) #.dup? # May throw NoPieceAtPosError

        raise InvalidEndPosError "Cannot move piece #{piece.class.name} to "\
        "#{end_pos.join('n')}"\
        unless piece.move_into_check?(end_pos)

        # No errors - go ahead!
        @rows[start_v][start_h] = nil
        @rows[end_v][end_h] = piece
        piece.pos = end_pos
    end

    def piece(pos)
        v, h = pos
        piece = @rows[v][h]
        
        raise NoPieceAtPosError "No piece found at pos #{pos.join(',')}}"\
        unless piece.is_a?(Piece)

        piece
    end
end

if __FILE__ == $0
    board = Board.new
    # p board.piece([3,3]) # Expect NoPieceAtPosError
    p board.piece([0,0]) # Expect to execute without error
    p board.move_piece([0,0], [4,4]) #Expect to have moved the piece 
    # p board.piece([0,0]) # Should throw NoPieceAtPosError after above line
    p board.piece([4,4]) # Should be the same piece as the first printed line
end
