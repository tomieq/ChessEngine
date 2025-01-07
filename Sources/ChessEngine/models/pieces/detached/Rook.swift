//
//  Rook.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Rook: DetachedChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.rook, color, square, longDistanceAttackDirections: MoveDirection.allStraight)
    }
}

extension Rook: ChessPieceConvertible {
    func chessPiece(chessBoard: ChessBoard) -> ChessPiece {
        ChessPiece(self, DistanceSniperMoveCalculator(for: self,
                                                      on: chessBoard,
                                                      longDistanceAttackDirections: MoveDirection.allStraight))
    }
}
