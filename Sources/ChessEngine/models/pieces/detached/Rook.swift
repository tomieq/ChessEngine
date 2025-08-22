//
//  Rook.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Rook: DetachedChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare, id: String? = nil) {
        self.init(.rook, color, square, longDistanceAttackDirections: MoveDirection.allStraight, id: id.or(.chessPieceID.appending("R\(square)")))
    }
}

extension Rook: ChessPieceConvertible {
    func chessPiece(chessBoard: ChessBoard) -> ChessPiece {
        ChessPiece(self, DistanceSniperMoveCalculator(for: self,
                                                      on: chessBoard,
                                                      longDistanceAttackDirections: MoveDirection.allStraight))
    }
}
