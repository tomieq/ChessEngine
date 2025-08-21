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
        color.pawnCrawlDirection
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
        square == startingSquare
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
    
    var squareAfterDoubleMove: BoardSquare? {
        switch color {
        case .white:
            BoardSquare(square.column, 4)
        case .black:
            BoardSquare(square.column, 5)
        }
    }

    var startingSquare: BoardSquare? {
        switch color {
        case .white:
            BoardSquare(square.column, 2)
        case .black:
            BoardSquare(square.column, 7)
        }
    }
}
