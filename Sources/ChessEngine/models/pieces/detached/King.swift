//
//  King.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class King: DetachedChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare, id: String? = nil) {
        self.init(.king, color, square, id: id.or(.chessPieceID.appending("K\(square)")))
    }
}

extension King: ChessPieceConvertible {
    func chessPiece(chessBoard: ChessBoard) -> ChessPiece {
        ChessPiece(self, KingMoveCalculator(for: self, on: chessBoard))
    }
}
