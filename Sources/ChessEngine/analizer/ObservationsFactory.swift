//
//  ObservationsFactory.swift
//  ChessEngine
//
//  Created by Tomasz on 14/01/2025.
//
import SwiftExtensions

public typealias ChessObservations = [ChessPieceColor: Set<ChessObservation>]

public class ObservationsFactory {
    let chessboard: ChessBoard
    
    public init(chessboard: ChessBoard) {
        self.chessboard = chessboard
    }
    
    public func analize() -> ChessObservations {
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
            if let observation = getFork(attacker: piece) {
                observations[piece.color]?.insert(observation)
            }
            if let observation = getDiscovery(attacker: piece) {
                observations[piece.color]?.insert(observation)
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
    
    private func getDiscovery(attacker: ChessPiece) -> ChessObservation? {
        guard let lastMove = chessboard.movesHistory.last,
              lastMove.movedPieces.contains(attacker).not,
              let freedSquare = lastMove.rawMove?.from else {
            return nil
        }
        guard attacker.longDistanceAttackDirections.isEmpty.not else {
            return nil
        }
        let victims = attacker.possibleVictims
            .compactMap { chessboard[$0] }
            .filter { victim in
                guard victim.type.isKing.not else {  return false }
                guard victim.type.weight > attacker.type.weight || victim.defenders.isEmpty else { return false }
                let path = attacker.square.path(to: victim.square)
                guard path.contains(freedSquare) else {
                    return false
                }
                return true
            }
        guard let victim = victims.first else {
            return nil
        }
        return .discoveredAttack(victim: victim, attacker: attacker)
    }
}

/*
 fork is an attack on two pieces:
 1. kwhen pieces are worth more than an attacker
 2. king + undefended piece
 3. two undefended pieces
 */
