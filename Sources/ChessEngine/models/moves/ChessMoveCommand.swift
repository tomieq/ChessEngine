//
//  ChessMoveCommand.swift
//  chess
//
//  Created by Tomasz Kucharski on 07/08/2024.
//

public enum ChessMoveCommand: Equatable {
    case move(ChessBoardMove, promotion: ChessPieceType?)
    case take(ChessBoardMove, promotion: ChessPieceType?)
    case castling(Castling)
    case enPassant(ChessBoardMove, taken: BoardSquare)
}
