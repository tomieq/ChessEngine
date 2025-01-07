//
//  Pawn.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Pawn: DetachedChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.pawn, color, square)
    }
}

extension Pawn: ChessPieceConvertible {
    func chessPiece(chessBoard: ChessBoard) -> ChessPiece {
        ChessPiece(self, PawnMoveCalculator(for: self, on: chessBoard))
    }
}
