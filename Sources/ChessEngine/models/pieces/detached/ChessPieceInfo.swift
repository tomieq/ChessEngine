//
//  ChessPieceInfo.swift
//  ChessEngine
//
//  Created by Tomasz on 20/01/2025.
//

public struct ChessPieceInfo {
    public let type: ChessPieceType
    public let color: ChessPieceColor
    public let square: BoardSquare
    public let moveCounter: Int
    public let possibleMoves: [BoardSquare]
    public let possibleVictims: [BoardSquare]
    public let possibleAttackers: [BoardSquare]
    public let defends: [BoardSquare]
    public let defenders: [BoardSquare]
    public let controlledSquares: [BoardSquare]
    public let pinInfo: PinInfo?
}

extension ChessPieceInfo: CustomStringConvertible {
    public var description: String {
        "\(self.color.enName) \(self.type.enName) on \(self.square)"
    }
}

extension ChessPieceInfo: Equatable {
    public static func == (lhs: ChessPieceInfo, rhs: ChessPieceInfo) -> Bool {
        lhs.color == rhs.color && lhs.square == rhs.square && lhs.type == rhs.type
    }
}
