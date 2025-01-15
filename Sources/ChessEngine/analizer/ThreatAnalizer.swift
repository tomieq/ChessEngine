//
//  ThreatAnalizer.swift
//  ChessEngine
//
//  Created by Tomasz on 14/01/2025.
//

public enum ChessThreat: Equatable {
    case fork(attacker: ChessPiece, victims: [ChessPiece])
    case freePiece(attacker: ChessPiece, victim: ChessPiece)
}

public class ThreatAnalizer {
    let chessboard: ChessBoard
    
    public init(chessboard: ChessBoard) {
        self.chessboard = chessboard
    }
    
    public func analize(attackerColor: ChessPieceColor) -> [ChessThreat] {
        var threats: [ChessThreat] = []
        chessboard.getPieces(color: attackerColor).forEach { piece in
            let piecesUnderAttack = piece
                .possibleVictims
                .compactMap { chessboard[$0] }
                .filter { piece.type.weight < $0.type.weight || $0.defenders.isEmpty }
            if piecesUnderAttack.count > 1 {
                threats.append(.fork(attacker: piece, victims: piecesUnderAttack))
            } else if let attackedPiece = piecesUnderAttack.first {
                threats.append(.freePiece(attacker: piece, victim: attackedPiece))
            }
        }
        return threats
    }
}

/*
 fork is an attack on two pieces:
  1. kwhen pieces are worth more than an attacker
  2. king + undefended piece
  3. two undefended pieces
 */
