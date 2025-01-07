//
//  Bishop.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Bishop: DetachedChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.bishop, color, square, longDistanceAttackDirections: MoveDirection.allDiagonal)
    }
}

extension Bishop: ChessPieceConvertible {
    func chessPiece(chessBoard: ChessBoard) -> ChessPiece {
        ChessPiece(self, DistanceSniperMoveCalculator(for: self,
                                                      on: chessBoard,
                                                      longDistanceAttackDirections: MoveDirection.allDiagonal))
    }
}
