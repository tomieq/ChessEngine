//
//  FenGenerator.swift
//  chess
//
//  Created by Tomasz Kucharski on 12/08/2024.
//

public class FenGenerator {
    let chessboard: ChessBoard
    
    public init(chessboard: ChessBoard) {
        self.chessboard = chessboard
    }
    
    public var fen: String {
        var result = fenSimple
        // castling possibilities
        var castling = ""
        if let king = chessboard["e1"], king.type == .king, king.moveCounter == 0 {
            if let rook = chessboard["h1"], rook.type == .rook, rook.moveCounter == 0 {
                castling.append("K")
            }
            if let rook = chessboard["a1"], rook.type == .rook, rook.moveCounter == 0 {
                castling.append("Q")
            }
        }
        if let king = chessboard["e8"], king.type == .king, king.moveCounter == 0 {
            if let rook = chessboard["h8"], rook.type == .rook, rook.moveCounter == 0 {
                castling.append("k")
            }
            if let rook = chessboard["a8"], rook.type == .rook, rook.moveCounter == 0 {
                castling.append("q")
            }
        }
        result.append(" \(castling.isEmpty ? "-" : castling)")
        // en passant possibilities
        var enPassantSquare = "-"
        if let lastMove = chessboard.movesHistory.last?.rawMove, let pawn = chessboard[lastMove.to],
           pawn.type == .pawn, abs(lastMove.from.row - lastMove.to.row) > 1,
           let square = lastMove.from.move(PawnUtils(square: lastMove.from, color: pawn.color).crawlingDirection) {
            enPassantSquare = "\(square)"
        }
        result.append(" \(enPassantSquare)")
        // number of half moves according to draw ruless TODO
        result.append(" 0")
        // number of full moves
        result.append(" \(chessboard.pgn.count / 2 + 1)")
        return result
    }
        
    public var fenSimple: String {
        "\(fenPosition) \(chessboard.colorOnMove.fenLetter)"
    }

    public var fenPosition: String {
        var position: [String] = []
        for row in (1...8).reversed() {
            var emptyCounter = 0
            var rowFen = ""
            for column in BoardColumn.allCases {
                if let piece = chessboard[BoardSquare(column, row)] {
                    if emptyCounter > 0 {
                        rowFen.append("\(emptyCounter)")
                        emptyCounter = 0
                    }
                    rowFen.append(piece.fenLetter)
                } else {
                    emptyCounter += 1
                }
            }
            if emptyCounter > 0 {
                rowFen.append("\(emptyCounter)")
            }
            position.append(rowFen)
        }
        return position.joined(separator: "/")
    }
}
