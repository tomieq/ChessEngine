//
//  MoveTests.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation
import XCTest
@testable import ChessEngine

class MoveTests: XCTestCase {
    
    let chessBoard = ChessBoard()
    
    func possibleMoves(from square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.possibleMoves ?? []
    }
    
    func defended(from square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.defends ?? []
    }
    
    func defenders(for square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.defenders ?? []
    }
    
    func possibleVictims(for square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.possibleVictims ?? []
    }
    
    func possibleAttackers(for square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.possibleAttackers ?? []
    }
}

