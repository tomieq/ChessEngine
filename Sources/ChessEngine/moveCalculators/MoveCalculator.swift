//
//  MoveCalculator.swift
//
//
//  Created by Tomasz on 04/04/2023.
//

import Foundation

protocol MoveCalculator {
    var moveCounter: Int { get }
    // fields where this piece can move (including possibleVictims)
    var possibleMoves: [BoardSquare] { get }
    
    // fields that this piece can attack
    var possibleVictims: [BoardSquare] { get }
    
    // fields that this piece might get attack from
    var possibleAttackers: [BoardSquare] { get }
    
    // fields that are defended by this piece
    var defends: [BoardSquare] { get }
    
    // fields that defend this piece
    var defenders: [BoardSquare] { get }
}

protocol MoveCalculatorProvider {
    func analize() -> CalculatedMoves
}

extension MoveCalculator where Self: MoveCalculatorProvider {
    var possibleMoves: [BoardSquare] {
        analize().possibleMoves
    }

    var possibleVictims: [BoardSquare] {
        analize().possibleVictims
    }
    
    var defends: [BoardSquare] {
        analize().defends
    }
    
    var defenders: [BoardSquare] {
        analize().defenders
    }
    
    var possibleAttackers: [BoardSquare] {
        analize().possibleAttackers
    }
    
    var pinned: Pinned? {
        analize().pinned
    }
}
