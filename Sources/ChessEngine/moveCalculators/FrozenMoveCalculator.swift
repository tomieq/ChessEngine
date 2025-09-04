//
//  FrozenMoveCalculator.swift
//  ChessEngine
//
//  Created by Tomasz on 04/09/2025.
//

// FrozenMoveCalculator does not watch ChessBoard for changes - it just stores last state
// Ideal for ChessPieces that were captured e.g. in history

class FrozenMoveCalculator: MoveCalculator {
    let moveCounter: Int
    let possibleMoves: [BoardSquare]
    let possibleVictims: [BoardSquare]
    let possibleAttackers: [BoardSquare]
    let defends: [BoardSquare]
    let defenders: [BoardSquare]
    let controlledSquares: [BoardSquare]
    let observation: ChessObservation?
    
    init(originalCalculator: MoveCalculator) {
        moveCounter = originalCalculator.moveCounter
        possibleMoves = originalCalculator.possibleMoves
        possibleVictims = originalCalculator.possibleVictims
        possibleAttackers = originalCalculator.possibleAttackers
        defends = originalCalculator.defends
        defenders = originalCalculator.defenders
        controlledSquares = originalCalculator.controlledSquares
        observation = originalCalculator.observation
    }
    
}
