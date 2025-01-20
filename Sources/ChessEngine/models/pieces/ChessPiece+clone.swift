//
//  ChessPiece+clone.swift
//  ChessEngine
//
//  Created by Tomasz on 20/01/2025.
//

extension ChessPiece {
    var gamePiece: GamePiece {
        switch self.type {
        case .king:
            King(self.type, self.color, self.square)
        case .queen:
            Queen(self.type, self.color, self.square)
        case .rook:
            Rook(self.type, self.color, self.square)
        case .bishop:
            Bishop(self.type, self.color, self.square)
        case .knight:
            Knight(self.type, self.color, self.square)
        case .pawn:
            Pawn(self.type, self.color, self.square)
        }
    }
}
