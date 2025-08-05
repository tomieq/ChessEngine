//
//  NotationFactory.swift
//  chess
//
//  Created by Tomasz Kucharski on 07/08/2024.
//

class NotationFactory {
    let chessBoard: ChessBoard
    
    init(chessBoard: ChessBoard) {
        self.chessBoard = chessBoard
    }
    
    // notation is composed for move that had already had place - pieces are
    func make(from command: ChessMoveCommand) -> String {
        var notation = ""
        switch command {
        case .move(let move, let promotion):
            if promotion.notNil {
                notation.append(move.from.column.letter.description)
            } else if let piece = chessBoard[move.to] {
                notation.append(piece.type.enLetter)
                let otherSameTypePiece = chessBoard
                    .getPieces(color: piece.color)
                    .filter { $0.type == piece.type && $0.type != .pawn && $0.square != piece.square}
                    .filter { $0.defends.contains(move.to) }
                    .filter { self.wasMoveAmbigious(move, for: $0) }
                    .first
                if let otherSameTypePiece = otherSameTypePiece {//}, otherSameTypePiece.possibleMoves.contains(move.to) {
                    if otherSameTypePiece.square.column == move.from.column {
                        notation.append("\(move.from.row)")
                    } else {
                        notation.append("\(move.from.column)")
                    }
                }
            }
            notation.append(move.to.description)
            if let promotedType = promotion {
                notation.append("=\(promotedType.enLetter)")
                notation.removeFirst()
            }
        case .take(let move, let promotion):
            if promotion.notNil {
                notation.append(move.from.column.letter.description)
            } else if let piece = chessBoard[move.to] {
                switch piece.type {
                case .pawn:
                    notation.append(move.from.column.letter.description)
                default:
                    notation.append(piece.type.enLetter)
                    let otherSameTypePiece = chessBoard
                        .getPieces(color: piece.color)
                        .filter { $0.type == piece.type && $0.type != .pawn && $0.square != piece.square}
                        .filter { $0.defends.contains(move.to) }
                        .filter { self.wasMoveAmbigious(move, for: $0) }
                        .first
                    if let otherSameTypePiece = otherSameTypePiece {
                        if otherSameTypePiece.square.column == move.from.column {
                            notation.append("\(move.from.row)")
                        } else {
                            notation.append("\(move.from.column)")
                        }
                    }
                }
            }
            notation.append("x\(move.to)")
            if let promotedType = promotion {
                notation.append("=\(promotedType.enLetter)")
            }
        case .castling(let castling):
            notation.append(castling.notation)
        case .enPassant(let move, _):
            notation.append("\(move.from.column.letter)x\(move.to)")
        }
        notation.append(chessBoard.status.notation)
        return notation
    }
    
    private func wasMoveAmbigious(_ move: ChessBoardMove, for piece: ChessPiece) -> Bool {
        if piece.longDistanceAttackDirections.isEmpty {
            return true
        }
        if piece.square.path(to: move.to).contains(move.from) {
            return false
        }
        return true
    }
}
