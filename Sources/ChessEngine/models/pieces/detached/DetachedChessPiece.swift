//
//  DetachedChessPiece.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

class DetachedChessPiece {
    let type: ChessPieceType
    let color: ChessPieceColor
    let square: BoardSquare
    let longDistanceAttackDirections: [MoveDirection]
    let id: String
    
    init(_ type: ChessPieceType, 
         _ color: ChessPieceColor,
         _ square: BoardSquare,
         longDistanceAttackDirections: [MoveDirection] = [],
         id: String) {
        self.type = type
        self.color = color
        self.square = square
        self.longDistanceAttackDirections = longDistanceAttackDirections
        self.id = id
    }
}
