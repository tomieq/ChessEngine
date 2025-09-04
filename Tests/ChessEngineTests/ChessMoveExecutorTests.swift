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
        let id = chessboard["e2"]?.id
        let sut = ChessMoveExecutor(chessboard: chessboard)
        let parser = NotationParser(moveExecutor: sut)
        try parser.process("""
        1. e4 f5
        2. exf5 e6
        3. fxe6
        """)
        XCTAssertEqual(id, chessboard["e6"]?.id)
        sut.revert()
        XCTAssertEqual(chessboard["e6"]?.type, .pawn)
        XCTAssertEqual(chessboard["f5"]?.type, .pawn)
    }
    
    func test_lastMovedPiecePromotion() throws {
        let chessboard = ChessBoard()
        let boardLoader = ChessBoardLoader(chessBoard: chessboard)
        let fenLoader = FenLoader(boardLoader: boardLoader)
        try fenLoader.load(fen: "rnbqk1nr/ppppp1bP/8/8/8/8/PPPP1PPP/RNBQKBNR b KQkq - 0 4")
        let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
        let commandFactory = ChessMoveCommandFactory(chessboard: chessboard)
        moveExecutor.process(try commandFactory.make(from: "e7", to: "e6"))
        XCTAssertEqual(chessboard.movesHistory.last?.movedPieces.first?.type, .pawn)
        XCTAssertEqual(chessboard.movesHistory.last?.movedPieces.first?.square, "e6")
        
        moveExecutor.process(try commandFactory.make(from: "h7", to: "g8"))
        XCTAssertEqual(chessboard.movesHistory.last?.movedPieces.first?.type, .queen)
        XCTAssertEqual(chessboard.movesHistory.last?.movedPieces.first?.square, "g8")
    }
    
    func test_lastMovedPieceCastling() throws {
        let chessboard = ChessBoard()
        let boardLoader = ChessBoardLoader(chessBoard: chessboard)
        let fenLoader = FenLoader(boardLoader: boardLoader)
        try fenLoader.load(fen: "r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3")
        let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
        let commandFactory = ChessMoveCommandFactory(chessboard: chessboard)
        moveExecutor.process(try commandFactory.make(from: "f8", to: "c5"))
        XCTAssertEqual(chessboard.movesHistory.last?.movedPieces.first?.type, .bishop)
        XCTAssertEqual(chessboard.movesHistory.last?.movedPieces.first?.square, "c5")
        
        moveExecutor.process(try commandFactory.make(from: "e1", to: "g1"))
        XCTAssertEqual(chessboard.movesHistory.last?.movedPieces.count, 2)
        XCTAssertTrue(chessboard.movesHistory.last!.movedPieces.contains(chessboard["g1"]!))
        XCTAssertTrue(chessboard.movesHistory.last!.movedPieces.contains(chessboard["f1"]!))
    }
    
    func test_lastMovedPieceLoadNewGame() throws {
        let chessboard = ChessBoard()
        let boardLoader = ChessBoardLoader(chessBoard: chessboard)
        let fenLoader = FenLoader(boardLoader: boardLoader)
        try fenLoader.load(fen: "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1")
        XCTAssertEqual(chessboard.movesHistory.count, 0)
        let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
        let commandFactory = ChessMoveCommandFactory(chessboard: chessboard)
        moveExecutor.process(try commandFactory.make(from: "e7", to: "e5"))
        XCTAssertEqual(chessboard.movesHistory.last?.movedPieces.first?.type, .pawn)
        XCTAssertEqual(chessboard.movesHistory.last?.movedPieces.first?.square, "e5")
        
        try fenLoader.load(fen: "r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/2N5/PPPP1PPP/R1BQK1NR b KQkq - 3 3")
        XCTAssertEqual(chessboard.movesHistory.count, 0)
    }
}
