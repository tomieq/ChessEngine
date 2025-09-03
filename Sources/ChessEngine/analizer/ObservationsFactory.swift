//
//  ObservationsFactory.swift
//  ChessEngine
//
//  Created by Tomasz on 14/01/2025.
//
import SwiftExtensions

public class ObservationsFactory {
    let chessboard: ChessBoard
    
    public init(chessboard: ChessBoard) {
        self.chessboard = chessboard
    }
    
    public func analize() -> [ChessPieceColor: Set<ChessObservation>] {
        var observations: [ChessPieceColor: Set<ChessObservation>] = [.white: Set(), .black: Set()]
        
        switch chessboard.status {
        case .normal:
            break
        case .check(let attackerColor):
            let attackers = chessboard.king(color: attackerColor.other)?.possibleAttackers.compactMap { chessboard[$0] }
            let observation = ChessObservation.check(attackers: attackers.or(.empty).set)
            observations[attackerColor]?.insert(observation)
        case .checkmate(let winnerColor):
            let attackers = chessboard.king(color: winnerColor.other)?.possibleAttackers.compactMap { chessboard[$0] }
            let observation = ChessObservation.checkMate(attackers: attackers.or(.empty).set)
            observations[winnerColor]?.insert(observation)
        }
        
        chessboard.allPieces.forEach { piece in
            piece.observation.onValue { observation in
                observations[piece.color.other]?.insert(observation)
            }
        }
        chessboard.allPieces.forEach { piece in
            if case .fork(let victims, let attacker) = getFork(attacker: piece) {
                observations[attacker.color]?.insert(.fork(victims: victims, attacker: attacker))
            }
        }
        
        chessboard.allPieces.filter{ $0.type.isKing.not }.forEach { piece in
            if piece.defenders.isEmpty, let square = piece.possibleAttackers.first, let attacker = chessboard[square] {
                observations[piece.color.other]?.insert(.freePiece(freePiece: piece, attacker: attacker))
            }
        }

        return observations
    }
    
    
    private func getFork(attacker: ChessPiece) -> ChessObservation? {
        // the piece is safe where it is
        var isAttackerSafe: Bool {
            let attackers = attacker.possibleAttackers.compactMap{ chessboard[$0] }
            if attackers.isEmpty { return true }
            // if piece has any defender and the attacker is king
            if attacker.defenders.isEmpty.not, (attackers.filter{ $0.type.isKing.not }).isEmpty {
                return true
            }
            // if number of defenders is bigger than attackers
            if attacker.defenders.count >= attackers.count {
                return true
            }
            return false
        }
        guard isAttackerSafe else {
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
        return .fork(victims: victims.set, attacker: attacker)
    }
}

/*
 fork is an attack on two pieces:
 1. kwhen pieces are worth more than an attacker
 2. king + undefended piece
 3. two undefended pieces
 */
