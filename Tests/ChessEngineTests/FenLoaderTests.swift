//
//  FenLoaderTests.swift
//  ChessEngine
//
//  Created by Tomasz on 10/01/2025.
//
import Foundation
@testable import ChessEngine
import XCTest

class FenLoaderTests: XCTestCase {
    func test_initialPosition() throws {
        let chessboard = ChessBoard()
        let boardLoader = ChessBoardLoader(chessBoard: chessboard)
        let sut = FenLoader(boardLoader: boardLoader)
        try sut.load(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
        let generator = FenGenerator(chessboard: chessboard)
        XCTAssertEqual(generator.fen, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    }
    
    func test_checkColorOnMove() throws {
        let chessboard = ChessBoard()
        let boardLoader = ChessBoardLoader(chessBoard: chessboard)
        let sut = FenLoader(boardLoader: boardLoader)
        try sut.load(fen: "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
        XCTAssertEqual(chessboard.colorOnMove, .black)
    }
}
