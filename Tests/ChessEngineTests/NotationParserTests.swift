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
    
    func test_parsingTimestamps() throws {
        let executor = moveExecutor
        let sut = NotationParser(moveExecutor: executor)
        try sut.process("""
        1. e4 {[%emt 00:00:45]} g6 {[%emt 00:00:04]} 2. d4 {[%emt 00:00:02]} Bg7 {[%emt
        00:00:02]} 3. Nf3 d6 4. Nc3 {[%emt 00:00:01]} Nd7 {[%emt 00:00:02]} 5. Be3
        {[%emt 00:00:01]} e5 {[%emt 00:00:01]} 6. d5 {[%emt 00:00:02]} Ne7 {[%emt
        00:00:03]} 7. Be2 {[%emt 00:00:03]} b6 {[%emt 00:00:02]} 8. O-O {[%emt
        00:00:02]} f5 {[%emt 00:00:03]} 9. exf5 {[%emt 00:00:10]} Nxf5 {[%emt
        00:00:02]} 10. Bg5 {[%emt 00:00:07]} Nf6 {[%emt 00:00:06]} 11. Bxf6 {[%emt
        00:00:11]} Bxf6 {[%emt 00:00:04]} 12. Ne4 {[%emt 00:00:06]} Bg7 {[%emt
        00:00:03]} 13. c4 {[%emt 00:00:06]} Bd7 {[%emt 00:00:03]} 14. b3 {[%emt
        00:00:06]} Qe7 {[%emt 00:00:05]} 15. Qd3 {[%emt 00:00:14]} O-O-O {[%emt
        00:00:20]} 16. a4 {[%emt 00:00:06]} Rdf8 {[%emt 00:00:08]} 17. a5 {[%emt
        00:00:11]} Nd4 {[%emt 00:00:10]} 18. Nxd4 {[%emt 00:00:14]} exd4 {[%emt
        00:00:03]} 19. axb6 {[%emt 00:00:22]} cxb6 {[%emt 00:00:12]} 20. Rxa7 {[%emt
        00:00:04]} Bf5 {[%emt 00:00:03]} 21. Rxe7 {[%emt 00:00:02]} 0-1
        """)
        let lastMove = executor.chessboard.movesHistory.last
        XCTAssertEqual(lastMove?.notation, "Rxe7")
    }
}




