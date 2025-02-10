//
//  MoveHistoryDependentCalculator.swift
//  ChessEngine
//
//  Created by Tomasz on 10/02/2025.
//

/*
 Some move calculators depend on previous moves, but as move history requires notification
 and NotificationParser triggers analize(), after appending move, the calculatedMoves need to
 be recalculated
 */
protocol MoveHistoryDependentCalculator {
    func wipe()
}
