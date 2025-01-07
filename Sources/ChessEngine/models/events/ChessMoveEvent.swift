//
//  ChessMoveEvent.swift
//  chess
//
//  Created by Tomasz Kucharski on 06/08/2024.
//

public enum ChessMoveEvent {
    case pieceMoved(type: ChessPieceType, move: ChessBoardMove, status: ChessGameStatus)
    case pieceTakes(type: ChessPieceType, move: ChessBoardMove, takenType: ChessPieceType, status: ChessGameStatus)
    case promotion(move: ChessBoardMove, type: ChessPieceType, status: ChessGameStatus)
    case castling(side: Castling, status: ChessGameStatus)
}
extension ChessMoveEvent: Equatable {}


extension ChessMoveEvent {
    public var notation: String {
        switch self {
        case .pieceMoved(let type, let move, let status):
            return "\(type.enLetter)\(move.to)\(status.notation)"
        case .pieceTakes(let type, let move, _, let status):
            var letter = type.enLetter
            if letter.isEmpty { letter = "\(move.from.column.letter)" }
            return "\(letter)x\(move.to)\(status.notation)"
        case .promotion(let move, let type, let status):
            return "\(move.to)=\(type.enLetter)\(status.notation)"
        case .castling(let side, let status):
            return "\(side.notation)\(status.notation)"
        }
    }
}
