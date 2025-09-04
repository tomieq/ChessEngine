//
//  ChessMove.swift
//  chess
//
//  Created by Tomasz Kucharski on 07/08/2024.
//

public struct ChessMove {
    public enum Change {
        case move(ChessBoardMove)
        case remove(ChessPieceType, ChessPieceColor, from: BoardSquare)
        case add(ChessPieceType, ChessPieceColor, to: BoardSquare)
    }
    public let color: ChessPieceColor
    public let notation: String
    public let changes: [Change]
    public let status: ChessGameStatus
    public let movedPieces: Set<ChessPiece> // pieces are on their new squares
}

extension ChessMove.Change: Equatable {}

extension ChessMove.Change {
    var reverted: ChessMove.Change {
        switch self {
        case .move(let move):
            return .move(ChessBoardMove(from: move.to, to: move.from))
        case .remove(let chessPieceType, let color, let from):
            return .add(chessPieceType, color, to: from)
        case .add(let chessPieceType, let color, let to):
            return .remove(chessPieceType, color, from: to)
        }
    }
}

extension ChessMove {
    var rawMove: ChessBoardMove? {
        changes.compactMap { change -> ChessBoardMove? in
            switch change {
            case .move(let chessBoardMove):
                return chessBoardMove
            default:
                return nil
            }
        }.first
    }
}
