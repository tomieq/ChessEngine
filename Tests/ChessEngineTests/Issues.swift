//
//  Issues.swift
//  ChessEngine
//
//  Created by Tomasz on 10/02/2025.
//

import Foundation
@testable import ChessEngine
import XCTest

class Issues: XCTestCase {
    func test_enpassant() throws {
        let chessboard = ChessBoard()
        let boardLoader = ChessBoardLoader(chessBoard: chessboard)
        let sut = FenLoader(boardLoader: boardLoader)
        try sut.load(fen: "8/8/8/1p3k2/p1p1rp1p/P1P4P/1P2R1P1/6K1 w - - 0 41")
        let fenGenerator = FenGenerator(chessboard: chessboard)
        let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
        let parser = NotationParser(moveExecutor: moveExecutor)
        let pngs = [
            "Kf2",
            "Rxe2+",
            "Kxe2",
            "Ke4",
            "Kd2",
            "f3",
            "g4",
            "hxg3"
        ]
        try pngs.forEach {
            try parser.process($0)
        }
        XCTAssertEqual("8/8/8/1p6/p1p1k3/P1P2ppP/1P1K4/8 w - - 0 5", fenGenerator.fen)
    }

    func test_KnightPromotion() throws {
        let chessboard = ChessBoard()
        let boardLoader = ChessBoardLoader(chessBoard: chessboard)
        let sut = FenLoader(boardLoader: boardLoader)
        try sut.load(fen: "5rk1/2r5/2p5/8/P2PB2q/3P4/3Q2p1/1R3NK1 w - -")
        let fenGenerator = FenGenerator(chessboard: chessboard)
        let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
        let parser = NotationParser(moveExecutor: moveExecutor)
        let pngs = [
            "Nh2",
            "Rf1+",
            "Rxf1",
            "Qxh2+",
            "Kxh2",
            "gxf1=N+",
            "Kg1",
            "Nxd2"
        ]
        try pngs.forEach {
            try parser.process($0)
        }
        XCTAssertEqual("6k1/2r5/2p5/8/P2PB3/3P4/3n4/6K1 w - - 0 5", fenGenerator.fen)
    }
    
    func test_enPassantInCheck() throws {
        let chessboard = ChessBoard()
        let boardLoader = ChessBoardLoader(chessBoard: chessboard)
        let sut = FenLoader(boardLoader: boardLoader)
        try sut.load(fen: "8/7N/2q1p3/3B1k1P/2Np1p2/8/2P1P1P1/5K2 b - -")
        let fenGenerator = FenGenerator(chessboard: chessboard)
        let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
        let parser = NotationParser(moveExecutor: moveExecutor)
        let pngs = [
            "Qxd5",
            "g4+",
            "fxg3"
        ]
        try pngs.forEach {
            try parser.process($0)
        }
        XCTAssertEqual("8/7N/4p3/3q1k1P/2Np4/6p1/2P1P3/5K2 w - - 0 2", fenGenerator.fen)
    }
    
    func test_loadFenEnPassantPossibility() throws {
        let chessboard = ChessBoard()
        let boardLoader = ChessBoardLoader(chessBoard: chessboard)
        let sut = FenLoader(boardLoader: boardLoader)
        try sut.load(fen: "r4r1k/1bp4p/p3p3/1p2Pp2/3p4/P3q1P1/1PP1BR1P/3QR1K1 w - f6 0 27")
        XCTAssertEqual(chessboard.possibleEnPassant, "f6")
        let fenGenerator = FenGenerator(chessboard: chessboard)
        let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
        let parser = NotationParser(moveExecutor: moveExecutor)
        let pngs = [
            "exf6"
        ]
        try pngs.forEach {
            try parser.process($0)
        }
        XCTAssertEqual(chessboard.possibleEnPassant, nil)
        XCTAssertEqual("r4r1k/1bp4p/p3pP2/1p6/3p4/P3q1P1/1PP1BR1P/3QR1K1 b - - 0 1", fenGenerator.fen)
    }
    
    func test_QueenPinCalculations() throws {
        let chessboard = ChessBoard()
        let boardLoader = ChessBoardLoader(chessBoard: chessboard)
        let sut = FenLoader(boardLoader: boardLoader)
        try sut.load(fen: "1r4k1/1p3qpp/p3b3/8/1QB3n1/5N2/P1P2PPP/1R2K2R w K - 3 22")
        let fenGenerator = FenGenerator(chessboard: chessboard)
        let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
        let parser = NotationParser(moveExecutor: moveExecutor)
        let pngs = [
            "Ng5",
            "Qxf2+"
        ]
        try pngs.forEach {
            try parser.process($0)
        }
        XCTAssertEqual("1r4k1/1p4pp/p3b3/6N1/1QB3n1/8/P1P2qPP/1R2K2R w K - 0 2", fenGenerator.fen)
    }
    
    func test_PawnPinCalculations() throws {
        let chessboard = ChessBoard()
        let boardLoader = ChessBoardLoader(chessBoard: chessboard)
        let sut = FenLoader(boardLoader: boardLoader)
        try sut.load(fen: "2r2rk1/p3pp1p/6pB/qpbbQ3/P7/1B3P2/2P3PP/5R1K b - -")
        let fenGenerator = FenGenerator(chessboard: chessboard)
        let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
        let parser = NotationParser(moveExecutor: moveExecutor)
        let pngs = [
            "f6"
        ]
        try pngs.forEach {
            try parser.process($0)
        }
        XCTAssertEqual("2r2rk1/p3p2p/5ppB/qpbbQ3/P7/1B3P2/2P3PP/5R1K w - - 0 1", fenGenerator.fen)
    }
    
    func test_KnightPinCalculations() throws {
        let chessboard = ChessBoard()
        let boardLoader = ChessBoardLoader(chessBoard: chessboard)
        let sut = FenLoader(boardLoader: boardLoader)
        try sut.load(fen: "rnb1kr2/5Npp/p1pP4/1p6/4n3/2P1q3/PN2B1PP/R2QR2K w q - 4 20")
        let fenGenerator = FenGenerator(chessboard: chessboard)
        let moveExecutor = ChessMoveExecutor(chessboard: chessboard)
        let parser = NotationParser(moveExecutor: moveExecutor)
        let pngs = [
            "Bh5",
            "Nf2+"
        ]
        try pngs.forEach {
            try parser.process($0)
        }
    }
}
