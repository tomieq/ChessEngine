//
//  ThreatAnalizer.swift
//  ChessEngine
//
//  Created by Tomasz on 14/01/2025.
//

public enum ChessThreat: Equatable, Comparable {
    case checkMate
    case fork(attacker: ChessPiece, victims: [ChessPiece])
    case pin(attacker: ChessPiece, pinned: ChessPiece, protected: ChessPiece)
    
    var value: Int {
        switch self {
        case .checkMate:
            100
        case .fork(_, let victims):
            victims.map { $0.type.weight }.min() ?? 0
        case .pin(_, let pinned, _):
            pinned.type.weight
        }
    }

    public static func < (lhs: ChessThreat, rhs: ChessThreat) -> Bool {
        lhs.value < rhs.value
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
        func getFork(attacker: ChessPiece) -> ChessThreat? {
            // the piece is safe where it is
            guard chessboard.controlledSquares(by: attacker.color.other).contains(attacker.square).not else {
                return nil
            }
            // check victims are stronger pieces or have no defenders
            let victims = attacker.possibleVictims
                .compactMap { chessboard[$0] }
                .filter { victim in
                    victim.type.weight > attacker.type.weight || victim.defenders.isEmpty
            }
            guard victims.count > 1 else {
                return nil
            }
            return .fork(attacker: attacker, victims: victims)
        }
        chessboard.getPieces(color: attackerColor).forEach { piece in
            if let fork = getFork(attacker: piece) {
                threats.append(fork)
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
