//
//  ThreatAnalizer.swift
//  ChessEngine
//
//  Created by Tomasz on 14/01/2025.
//

public enum ChessThreat: Equatable {
    case checkMate
    case fork(attacker: ChessPiece, victims: [ChessPiece])
    case pin(attacker: ChessPiece, pinned: ChessPiece, protected: ChessPiece)
    case freePiece(attacker: ChessPiece, victim: ChessPiece)
    
    var value: Int {
        switch self {
        case .checkMate:
            100
        case .fork(_, let victims):
            victims.map { $0.type.weight }.min() ?? 0
        case .pin(_, let pinned, _):
            pinned.type.weight
        case .freePiece(_, _):
            1
        }
    }
}

public class ThreatAnalizer {
    let chessboard: ChessBoard
    
    public init(chessboard: ChessBoard) {
        self.chessboard = chessboard
    }
    
    public func analize(attackerColor: ChessPieceColor) -> [ChessThreat] {
        if chessboard.isCheckMated(attackerColor.other) {
            return [.checkMate]
        }
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
        chessboard.getPieces(color: attackerColor.other).forEach { piece in
            if let pinInfo = piece.pinInfo {
                if pinInfo.attacker.type.weight < piece.type.weight {
                    threats.append(.pin(attacker: pinInfo.attacker, pinned: piece, protected: pinInfo.coveredVictim))
                }
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
