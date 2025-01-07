//
//  ChessBoardMove.swift
//  chess
//
//  Created by Tomasz Kucharski on 06/08/2024.
//

public struct ChessBoardMove {
    public let from: BoardSquare
    public let to: BoardSquare
}

extension ChessBoardMove: Equatable {}

extension ChessBoardMove: CustomStringConvertible {
    public var description: String {
        "from \(from) to \(to)"
    }
}
