//
//  CalculatedMoves.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

public struct PinInfo {
    public let attacker: ChessPiece
    public let coveredVictim: ChessPiece
}

struct CalculatedMoves {
    let possibleMoves: [BoardSquare]
    let possibleVictims: [BoardSquare]
    let possibleAttackers: [BoardSquare]
    let defends: [BoardSquare]
    let defenders: [BoardSquare]
    let controlledSquares: [BoardSquare]
    let pinInfo: PinInfo?
}
