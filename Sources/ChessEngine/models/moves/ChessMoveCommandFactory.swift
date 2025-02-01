//
//  ChessMoveCommandFactory.swift
//  chess
//
//  Created by Tomasz Kucharski on 07/08/2024.
//

// ChessMoveCommandFactory validates and produces [ChessMoveCommand] out of UI requests
import Logger

public enum ChessMoveCommandFactoryError: Error {
    case invalidSquare
    case noPiece(at: BoardSquare)
    case colorOnMove(ChessPieceColor)
    case canNotMove(type: ChessPieceType, to: BoardSquare)
}

public class ChessMoveCommandFactory {
    private let logger = Logger(ChessMoveCommandFactory.self)
    let chessboard: ChessBoard
    
    public init(chessboard: ChessBoard) {
        self.chessboard = chessboard
    }
    
    public func make(from: BoardSquare?, to: BoardSquare?) throws -> ChessMoveCommand {
        guard let from = from, let to = to else {
            logger.e("Invalid square")
            throw ChessMoveCommandFactoryError.invalidSquare
        }
        let move = ChessBoardMove(from: from, to: to)
        guard let piece = chessboard[from] else {
            logger.e("No piece at \(from)")
            throw ChessMoveCommandFactoryError.noPiece(at: from)
        }
        guard piece.color == chessboard.colorOnMove else {
            logger.e("Cannot move with \(piece) as now only \(chessboard.colorOnMove) can move now")
            throw ChessMoveCommandFactoryError.colorOnMove(chessboard.colorOnMove)
        }
        guard piece.possibleMoves.contains(to) else {
            logger.e("\(piece) cannot move to \(to). It can move only to \(piece.possibleMoves)")
            throw ChessMoveCommandFactoryError.canNotMove(type: piece.type, to: to)
        }

        if let event = castlingMove(piece: piece, move: move) { return event }
        if let event = enPassantMove(piece: piece, move: move) { return event }
        if let _ = chessboard[to] {
            return .take(move, promotion: promotionType(piece: piece, move: move))
        } else {
            return .move(move, promotion: promotionType(piece: piece, move: move))
        }
    }
    
    private func enPassantMove(piece: ChessPiece, move: ChessBoardMove)  -> ChessMoveCommand? {
        guard piece.type == .pawn else { return nil }
        guard chessboard[move.to].isNil else { return nil }
        let pawn = PawnUtils(square: piece.square, color: piece.color)
        if let enPassantSquare = (pawn.enPassantSquares.filter { $0 == move.to }.first),
           let taken = enPassantSquare.move(pawn.crawlingDirection.opposite) {
            logger.i("en passant move \(move)")
            return .enPassant(move, taken: taken)
        }
        return nil
    }

    private func castlingMove(piece: ChessPiece, move: ChessBoardMove) -> ChessMoveCommand? {
        if piece.type == .king, piece.moveCounter == 0 {
            switch piece.color {
            case .white:
                if move.from == "e1" {
                    if move.to == "g1" {
                        return .castling(Castling.kingSide(.white))
                    }
                    if move.to == "c1" {
                        return .castling(Castling.queenSide(.white))
                    }
                }
            case .black:
                if move.from == "e8" {
                    if move.to == "g8" {
                        return .castling(Castling.kingSide(.black))
                    }
                    if move.to == "c8" {
                        return .castling(Castling.queenSide(.black))
                    }
                }
            }
            
        }
        return nil
    }
    
    private func promotionType(piece: ChessPiece, move: ChessBoardMove) -> ChessPieceType? {
        if piece.type == .pawn {
            switch piece.color {
            case .white:
                if move.to.row == 8 {
                    return .queen
                }
            case .black:
                if move.to.row == 1 {
                    return .queen
                }
            }
        }
        return nil
    }
}
