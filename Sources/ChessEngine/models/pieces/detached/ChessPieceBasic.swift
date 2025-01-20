//
//  ChessPieceBasic.swift
//  ChessEngine
//
//  Created by Tomasz on 20/01/2025.
//

public struct ChessPieceBasic {
    public let type: ChessPieceType
    public let color: ChessPieceColor
    public let square: BoardSquare
}

extension ChessPieceBasic: Equatable {
    public static func == (lhs: ChessPieceBasic, rhs: ChessPieceBasic) -> Bool {
        lhs.color == rhs.color && lhs.square == rhs.square && lhs.type == rhs.type
    }
}
