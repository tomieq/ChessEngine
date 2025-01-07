//
//  PawnUtils.swift
//  chess
//
//  Created by Tomasz Kucharski on 09/08/2024.
//

struct PawnUtils {
    let square: BoardSquare
    let color: ChessPieceColor

    var crawlingDirection: MoveDirection {
        switch color {
        case .white:
            return .up
        case .black:
            return .down
        }
    }

    var attackDirections: [MoveDirection] {
        switch color {
        case .white:
            return [.upLeft, .upRight]
        case .black:
            return [.downLeft, .downRight]
        }
    }

    var isAtStartingSquare: Bool {
        switch color {
        case .white:
            return square.row == 2
        case .black:
            return square.row == 7
        }
    }
    
    var enPassantDirections: [MoveDirection] {
        var directions: [MoveDirection?] = []
        switch color {
        case .white:
            guard square.row == 5 else { return [] }
            directions = [.upRight, .upLeft]
        case .black:
            guard square.row == 4 else { return [] }
            directions = [.downRight, .downLeft]
        }
        return directions.compactMap { $0 }
    }
    
    var enPassantSquares: [BoardSquare] {
        enPassantDirections.compactMap { square.move($0) }
    }
}
