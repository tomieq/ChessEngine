//
//  NotationParserTests.swift
//  chess
//
//  Created by Tomasz Kucharski on 06/08/2024.
//

import Foundation
import XCTest
@testable import ChessEngine

class NotationParserTests: XCTestCase {
    
    var moveExecutor: ChessMoveExecutor {
        let board = ChessBoard()
        board.setupGame()
        return ChessMoveExecutor(chessboard: board)
    }
    
    func test_basicMoves() throws {
        let executor = moveExecutor
        let sut = NotationParser(moveExecutor: executor)
        try sut.process("""
        1. e4 e5
        2. Nf3 Nc6
        3. Bc4
        """)
        XCTAssertEqual(executor.chessboard["e4"]?.type, .pawn)
        XCTAssertEqual(executor.chessboard["e5"]?.type, .pawn)
        XCTAssertEqual(executor.chessboard["f3"]?.type, .knight)
        XCTAssertEqual(executor.chessboard["c6"]?.type, .knight)
        XCTAssertEqual(executor.chessboard["c4"]?.type, .bishop)
    }
    
    func test_quickCheck() throws {
        let executor = moveExecutor
        let sut = NotationParser(moveExecutor: executor)
        try sut.process("""
        e4 e5
        Sc3 f5
        Hh5+
        """)
        XCTAssertEqual(executor.chessboard.status, .check(attacker: .white))
    }
    
    func test_quickCheckMate() throws {
        let executor = moveExecutor
        let sut = NotationParser(moveExecutor: executor)
        try sut.process("""
        e4 e5
        Hh5? Sc6
        Gc4 Sf6??
        Hxf7#
        """)
        XCTAssertEqual(executor.chessboard.status, .checkmate(winner: .white))
    }
    
    func test_enPassant() throws {
        let executor = moveExecutor
        let sut = NotationParser(moveExecutor: executor)
        try sut.process("""
        e4 h6
        e5 d5
        exd6
        """)
        let lastMove = executor.chessboard.movesHistory.last
        XCTAssertEqual(lastMove?.notation, "exd6")
        XCTAssertEqual(lastMove?.changes.contains(.remove(.pawn, .black, from: "d5")), true)
    }
}




