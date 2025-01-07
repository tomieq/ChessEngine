//
//  ChessMoveExecutorTests.swift
//  chess
//
//  Created by Tomasz Kucharski on 09/08/2024.
//

import XCTest
@testable import ChessEngine

final class ChessMoveExecutorTests: XCTestCase {
    func test_revert() throws {
        let chessboard = ChessBoard()
        chessboard.setupGame()
        let sut = ChessMoveExecutor(chessboard: chessboard)
        let parser = NotationParser(moveExecutor: sut)
        try parser.process("""
        1. e4 f5
        2. exf5 e6
        3. fxe6
        """)
        sut.revert()
        XCTAssertEqual(chessboard["e6"]?.type, .pawn)
        XCTAssertEqual(chessboard["f5"]?.type, .pawn)
    }
}
