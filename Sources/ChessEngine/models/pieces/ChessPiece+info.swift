//
//  ChessPiece+info.swift
//  ChessEngine
//
//  Created by Tomasz on 20/01/2025.
//

extension ChessPiece {
    var info: ChessPieceInfo {
        ChessPieceInfo(type: type,
                       color: color,
                       square: square,
                       moveCounter: moveCounter,
                       possibleMoves: possibleMoves,
                       possibleVictims: possibleVictims,
                       possibleAttackers: possibleAttackers,
                       defends: defends,
                       defenders: defenders,
                       controlledSquares: controlledSquares,
                       pinInfo: pinInfo)
    }
}
