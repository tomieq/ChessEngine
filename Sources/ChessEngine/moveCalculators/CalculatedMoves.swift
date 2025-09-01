//
//  CalculatedMoves.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

struct CalculatedMoves {
    let possibleMoves: [BoardSquare]
    let possibleVictims: [BoardSquare]
    let possibleAttackers: [BoardSquare]
    let defends: [BoardSquare]
    let defenders: [BoardSquare]
    let controlledSquares: [BoardSquare]
    let observation: ChessObservation?
}
