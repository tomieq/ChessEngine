//
//  FenGeneratorTests.swift
//  chess
//
//  Created by Tomasz Kucharski on 12/08/2024.
//

import Foundation
@testable import ChessEngine
import XCTest

class FenGeneratorTests: XCTestCase {
    func test_initialPosition() {
        let chessboard = ChessBoard()
        chessboard.setupGame()
        let sut = FenGenerator(chessboard: chessboard)
        XCTAssertEqual(sut.fen, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    }
    
    func test_e4Move() throws {
        let chessboard = ChessBoard()
        chessboard.setupGame()
        let commandFactory = ChessMoveCommandFactory(chessboard: chessboard)
        let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
        moveExecutor.process(try commandFactory.make(from: "e2", to: "e4"))
        let sut = FenGenerator(chessboard: chessboard)
        XCTAssertEqual(sut.fen, "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
    }
    
    func test_e4c5Move() throws {
        let chessboard = ChessBoard()
        chessboard.setupGame()
        let commandFactory = ChessMoveCommandFactory(chessboard: chessboard)
        let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
        moveExecutor.process(try commandFactory.make(from: "e2", to: "e4"))
        moveExecutor.process(try commandFactory.make(from: "c7", to: "c5"))
        let sut = FenGenerator(chessboard: chessboard)
        XCTAssertEqual(sut.fen, "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2")
    }
    
    func test_importedEnPasant() throws {
        let chessboard = ChessBoard()
        let boardLoader = ChessBoardLoader(chessBoard: chessboard)
        let fenLoader = FenLoader(boardLoader: boardLoader)
        try fenLoader.load(fen: "2r5/p5bk/q2Bp1pp/1p1nPp2/4Q2P/P4N2/1PR2PP1/6K1 w - f6")
        let sut = FenGenerator(chessboard: chessboard)
        XCTAssertTrue(sut.fen.contains("2r5/p5bk/q2Bp1pp/1p1nPp2/4Q2P/P4N2/1PR2PP1/6K1 w - f6"))
    }
}
