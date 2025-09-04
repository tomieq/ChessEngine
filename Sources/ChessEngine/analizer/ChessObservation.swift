//
//  ChessState.swift
//  ChessEngine
//
//  Created by Tomasz on 22/08/2025.
//

// There are observations for white and black
// observation is assigned to color that advantages from it

public enum ChessObservation {
    case pinnedToKing(pinnedPiece: ChessPiece, attacker: ChessPiece)
    case pinned(pinnedPiece: ChessPiece, attacker: ChessPiece, coveredPiece: ChessPiece)
    case freePiece(freePiece: ChessPiece, attacker: ChessPiece)
    case fork(victims: Set<ChessPiece>, attacker: ChessPiece)
    case discoveredAttack(victim: ChessPiece, attacker: ChessPiece)
    case check(attackers: Set<ChessPiece>)
    case checkMate(attackers: Set<ChessPiece>)
    
    var simple: ChessSimpleObservation {
        switch self {
        case .pinnedToKing:     .pinnedToKing
        case .pinned:           .pinned
        case .freePiece:        .freePiece
        case .fork:             .fork
        case .discoveredAttack: .discoveredAttack
        case .check:            .check
        case .checkMate:        .checkMate
        }
    }
}

public enum ChessSimpleObservation {
    case pinnedToKing
    case pinned
    case freePiece
    case fork
    case discoveredAttack
    case check
    case checkMate
}

extension ChessObservation {
    var id: String {
        switch self {
        case .pinnedToKing(let pinnedPiece, let attacker):
            "p2k-\(pinnedPiece.id)-\(attacker.id)"
        case .pinned(let pinnedPiece, let attacker, let coveredPiece):
            "p2e-\(pinnedPiece.id)-\(attacker.id)-\(coveredPiece.id)"
        case .freePiece(let freePiece, let attacker):
            "fp-\(freePiece.id)-\(attacker.id)"
        case .fork(let victims, let attacker):
            "frk-\(Set(victims).hashValue)-\(attacker.id)"
        case .discoveredAttack(let victim, let attacker):
            "da-\(victim.id)-\(attacker.id)"
        case .check(let attackers):
            "c-\(Set(attackers).hashValue)"
        case .checkMate(let attackers):
            "cm-\(Set(attackers).hashValue)"
        }
    }
}

extension ChessObservation: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ChessObservation: Equatable {
    public static func == (lhs: ChessObservation, rhs: ChessObservation) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension ChessSimpleObservation: Equatable {}

extension ChessObservation {
    var frozen: ChessObservation {
        switch self {
        case .pinnedToKing(pinnedPiece: let pinnedPiece, attacker: let attacker):
                .pinnedToKing(pinnedPiece: pinnedPiece.frozen, attacker: attacker.frozen)
        case .pinned(pinnedPiece: let pinnedPiece, attacker: let attacker, coveredPiece: let coveredPiece):
                .pinned(pinnedPiece: pinnedPiece.frozen, attacker: attacker.frozen, coveredPiece: coveredPiece.frozen)
        case .freePiece(freePiece: let freePiece, attacker: let attacker):
                .freePiece(freePiece: freePiece.frozen, attacker: attacker.frozen)
        case .fork(victims: let victims, attacker: let attacker):
                .fork(victims: victims.map { $0.frozen }.set, attacker: attacker.frozen)
        case .discoveredAttack(victim: let victim, attacker: let attacker):
                .discoveredAttack(victim: victim.frozen, attacker: attacker.frozen)
        case .check(attackers: let attackers):
                .check(attackers: attackers.map { $0.frozen }.set)
        case .checkMate(attackers: let attackers):
                .checkMate(attackers: attackers.map { $0.frozen }.set)
        }
    }
    
    public var forkedVictims: Set<ChessPiece> {
        switch self {
        case .fork(victims: let victims, attacker: _):
            return victims
        default:
            return []
        }
    }
}
