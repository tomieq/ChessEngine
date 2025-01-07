//
//  ChessBoardEvent.swift
//  
//
//  Created by Tomasz on 06/08/2024.
//

import Foundation

struct ChessBoardEvent {
    enum Change {
        case pieceAdded(at: [BoardSquare])
        case pieceMoved(ChessBoardMove)
        case pieceRemoved(from: BoardSquare)
    }
    let change: Change
    let mode: ChessMoveMode
}


enum ChessMoveMode {
    case normal
    case revert
}
