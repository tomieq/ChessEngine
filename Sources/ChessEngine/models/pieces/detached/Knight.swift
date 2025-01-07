//
//  Knight.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Knight: DetachedChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.knight, color, square)
    }
}

extension Knight: ChessPieceConvertible {
    func chessPiece(chessBoard: ChessBoard) -> ChessPiece {
        ChessPiece(self, KnightMoveCalculator(for: self, on: chessBoard))
    }
}
