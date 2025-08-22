//
//  Queen.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Queen: DetachedChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare, id: String? = nil) {
        self.init(.queen, color, square, longDistanceAttackDirections: MoveDirection.allCases, id: id.or(.chessPieceID.appending("Q\(square)")))
    }
}

extension Queen: ChessPieceConvertible {
    func chessPiece(chessBoard: ChessBoard) -> ChessPiece {
        ChessPiece(self, DistanceSniperMoveCalculator(for: self,
                                                      on: chessBoard,
                                                      longDistanceAttackDirections: MoveDirection.allCases))
    }
}
