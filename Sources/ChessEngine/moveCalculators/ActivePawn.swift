//
//  ActivePawn.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

struct ActivePawn {
    let color: ChessPieceColor
    let square: BoardSquare
    
    var attackedSquares: [BoardSquare] {
        var directions: [MoveDirection] = []
        switch self.color {
        case .white:
            directions.append(contentsOf: [.upLeft, .upRight])
        case .black:
            directions.append(contentsOf: [.downLeft, .downRight])
        }
        return directions.compactMap { square.move($0) }
    }
}
