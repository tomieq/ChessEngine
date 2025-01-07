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
    
    func make(from command: ChessMoveCommand) -> String {
        var notation = ""
        switch command {
        case .move(let move, let promotion):
            if let piece = chessBoard[move.to] {
                notation.append(piece.type.enLetter)
                let otherSameTypePiece = chessBoard
                    .getPieces(color: piece.color)
                    .filter { $0.type == piece.type && $0.type != .pawn && $0.square != piece.square}
                    .filter { $0.moveCalculator.defends.contains(move.to) }
                    .first
                if let otherSameTypePiece = otherSameTypePiece {
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
            }
        case .take(let move, let promotion):
            if let piece = chessBoard[move.to] {
                switch piece.type {
                case .pawn:
                    notation.append(move.from.column.letter.description)
                default:
                    notation.append(piece.type.enLetter)
                    let otherSameTypePiece = chessBoard
                        .getPieces(color: piece.color)
                        .filter { $0.type == piece.type && $0.type != .pawn && $0.square != piece.square}
                        .filter { $0.moveCalculator.defends.contains(move.to) }
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
        print(notation)
        return notation
    }
}
