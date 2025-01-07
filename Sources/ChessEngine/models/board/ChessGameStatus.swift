//
//  ChessGameStatus.swift
//  chess
//
//  Created by Tomasz Kucharski on 06/08/2024.
//

public enum ChessGameStatus {
    case normal
    case check(attacker: ChessPieceColor)
    case checkmate(winner: ChessPieceColor)
}
extension ChessGameStatus: Equatable {}

extension ChessGameStatus {
    var notation: String {
        switch self {
        case .normal:
            ""
        case .check:
            "+"
        case .checkmate:
            "#"
        }
    }
}
