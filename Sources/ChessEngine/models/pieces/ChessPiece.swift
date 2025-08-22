//
//  ChessPiece.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation


public struct ChessPiece {
    public let type: ChessPieceType
    public let color: ChessPieceColor
    public let square: BoardSquare
    let longDistanceAttackDirections: [MoveDirection]
    let moveCalculator: MoveCalculator
    public let id: String

    init(_ detached: DetachedChessPiece,
         _ moveCalculator: MoveCalculator) {
        self.type = detached.type
        self.color = detached.color
        self.longDistanceAttackDirections = detached.longDistanceAttackDirections
        self.square = detached.square
        self.moveCalculator = moveCalculator
        self.id = detached.id
    }
    
    func moved(to square: BoardSquare) -> ChessPiece {
        ChessPiece(DetachedChessPiece(type,
                                      color,
                                      square,
                                      longDistanceAttackDirections: longDistanceAttackDirections,
                                      id: self.id),
                   moveCalculator)
    }
}

extension ChessPiece: MoveCalculator {
    public var moveCounter: Int {
        moveCalculator.moveCounter
    }
    
    public var possibleMoves: [BoardSquare] {
        moveCalculator.possibleMoves
    }
    
    public var possibleVictims: [BoardSquare] {
        moveCalculator.possibleVictims
    }
    
    public var possibleAttackers: [BoardSquare] {
        moveCalculator.possibleAttackers
    }
    
    public var defends: [BoardSquare] {
        moveCalculator.defends
    }
    
    public var defenders: [BoardSquare] {
        moveCalculator.defenders
    }
    
    public var controlledSquares: [BoardSquare] {
        moveCalculator.controlledSquares
    }
    
    public var pinInfo: PinInfo? {
        moveCalculator.pinInfo
    }
}

extension ChessPiece {
    public var fenLetter: String {
        var letter = self.type == .pawn ? "P" : self.type.enLetter
        if self.color == .black {
            letter = letter.lowercased()
        }
        return letter
    }
}

extension ChessPiece: Equatable {
    public static func == (lhs: ChessPiece, rhs: ChessPiece) -> Bool {
        lhs.id == rhs.id
    }
}

extension ChessPiece: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.type)
        hasher.combine(self.color)
        hasher.combine(self.square)
    }
}

extension ChessPiece: CustomStringConvertible {
    public var description: String {
        "\(self.color.enName) \(self.type.enName) on \(self.square)"
    }
}

extension ChessPiece {
    var gamePiece: GamePiece {
        switch self.type {
        case .king:
            King(self.type, self.color, self.square, id: self.id)
        case .queen:
            Queen(self.type, self.color, self.square, id: self.id)
        case .rook:
            Rook(self.type, self.color, self.square, id: self.id)
        case .bishop:
            Bishop(self.type, self.color, self.square, id: self.id)
        case .knight:
            Knight(self.type, self.color, self.square, id: self.id)
        case .pawn:
            Pawn(self.type, self.color, self.square, id: self.id)
        }
    }
}
