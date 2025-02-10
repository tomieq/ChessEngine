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
    func test_fenEnpassant() throws {
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
        pngs.forEach {
            try? parser.process($0)
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
        pngs.forEach {
            try? parser.process($0)
        }
        XCTAssertEqual("6k1/2r5/2p5/8/P2PB3/3P4/3n4/6K1 w - - 0 5", fenGenerator.fen)
    }
}
