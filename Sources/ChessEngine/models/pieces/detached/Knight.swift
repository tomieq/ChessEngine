//
//  Knight.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Knight: DetachedChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare, id: String? = nil) {
        self.init(.knight, color, square, id: id.or(.chessPieceID.appending("N\(square)")))
    }
}

extension Knight: ChessPieceConvertible {
    func chessPiece(chessBoard: ChessBoard) -> ChessPiece {
        ChessPiece(self, KnightMoveCalculator(for: self, on: chessBoard))
    }
}
