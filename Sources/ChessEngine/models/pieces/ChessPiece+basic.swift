//
//  ChessPiece+basic.swift
//  ChessEngine
//
//  Created by Tomasz on 20/01/2025.
//

extension ChessPiece {
    var basic: ChessPieceBasic {
        ChessPieceBasic(type: type,
                        color: color,
                        square: square)
    }
}
