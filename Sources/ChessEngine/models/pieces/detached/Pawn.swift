//
//  Pawn.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Pawn: DetachedChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare, id: String? = nil) {
        self.init(.pawn, color, square, id: id.or(.chessPieceID.appending("P\(square)")))
    }
}

extension Pawn: ChessPieceConvertible {
    func chessPiece(chessBoard: ChessBoard) -> ChessPiece {
        ChessPiece(self, PawnMoveCalculator(for: self, on: chessBoard))
    }
}
