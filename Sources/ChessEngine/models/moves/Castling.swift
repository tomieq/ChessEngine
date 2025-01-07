//
//  Castling.swift
//  chess
//
//  Created by Tomasz Kucharski on 06/08/2024.
//

public enum Castling {
    case kingSide(ChessPieceColor)
    case queenSide(ChessPieceColor)
    
    public var moves: [ChessBoardMove] {
        switch self {
        case .kingSide(let color):
            switch color {
            case .white:
                [ChessBoardMove(from: "e1", to: "g1"), ChessBoardMove(from: "h1", to: "f1")]
            case .black:
                [ChessBoardMove(from: "e8", to: "g8"), ChessBoardMove(from: "h8", to: "f8")]
            }
        case .queenSide(let color):
            switch color {
            case .white:
                [ChessBoardMove(from: "e1", to: "c1"), ChessBoardMove(from: "a1", to: "d1")]
            case .black:
                [ChessBoardMove(from: "e8", to: "c8"), ChessBoardMove(from: "a8", to: "d8")]
            }
        }
    }
}
extension Castling: Equatable {}

extension Castling {
    var notation: String {
        switch self {
        case .kingSide:
            "O-O"
        case .queenSide:
            "O-O-O"
        }
    }
}
