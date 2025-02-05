//
//  ThreatAnalizerTests.swift
//  ChessEngine
//
//  Created by Tomasz on 14/01/2025.
//

import Foundation
@testable import ChessEngine
import XCTest

class ThreatAnalizerTests: MoveTests {
    
    func testBishopFork() throws {
        let board = ChessBoard()
        let analizer = ThreatAnalizer(chessboard: board)
        ChessBoardLoader(chessBoard: board)
            .load(.white, "Kb1 a2 b3 c2 Bg4")
            .load(.black, "Kc8 a6 b5 Rh3")
        let threats = analizer.analize(attackerColor: .white)
        if case .fork(let attacker, let victims) = threats.first {
            XCTAssertEqual(attacker.square, "g4")
            let squares = victims.map { $0.square }
            XCTAssertTrue(squares.contains("c8"))
            XCTAssertTrue(squares.contains("h3"))
        } else {
            XCTFail("Invalid thread type")
        }
    }
    
    func testNightForkOnKingAndQeen() throws {
        let board = ChessBoard()
        let analizer = ThreatAnalizer(chessboard: board)
        ChessBoardLoader(chessBoard: board)
            .load(.white, "Kg2 Qe2 h3 f2 Be1 Rd1 b2 a3")
            .load(.black, "h5 Kg8 g7 Qg6 f7 Nf4 Re8 d5 b6 a5")
        let threats = analizer.analize(attackerColor: .black)
        if case .fork(let attacker, let victims) = threats.first {
            XCTAssertEqual(attacker.square, "f4")
            let squares = victims.map { $0.square }
            XCTAssertTrue(squares.contains("g2"))
            XCTAssertTrue(squares.contains("e2"))
        } else {
            XCTFail("Invalid thread type")
        }
    }
    
    func testNightTripleFork() throws {
        let board = ChessBoard()
        let analizer = ThreatAnalizer(chessboard: board)
        ChessBoardLoader(chessBoard: board)
            .load(.white, "Ka1 a2 b2 Rc1 Nf7")
            .load(.black, "Qd8 Rg5 Kh8")
        let threats = analizer.analize(attackerColor: .white)
        if case .fork(let attacker, let victims) = threats.first {
            XCTAssertEqual(attacker.square, "f7")
            let squares = victims.map { $0.square }
            XCTAssertTrue(squares.contains("h8"))
            XCTAssertTrue(squares.contains("d8"))
            XCTAssertTrue(squares.contains("g5"))
        } else {
            XCTFail("Invalid thread type")
        }
    }
    
    func testPawnFork() throws {
        let board = ChessBoard()
        let analizer = ThreatAnalizer(chessboard: board)
        ChessBoardLoader(chessBoard: board)
            .load(.white, "Ra1 a2 Nb1 b2 Bb3 c3 Qd1 d5 Re1 e4 f2 Nf3 Kg1 g2 Bg5 h3")
            .load(.black, "a6 Rb8 Bb6 b5 c7 Nc6 Qd8 d6 Be6 e5 Rf8 f7 Nf6 Kg8 g7 h7")
        let threats = analizer.analize(attackerColor: .white)
        if case .fork(let attacker, let victims) = threats.first {
            XCTAssertEqual(attacker.square, "d5")
            let squares = victims.map { $0.square }
            XCTAssertTrue(squares.contains("c6"))
            XCTAssertTrue(squares.contains("e6"))
        } else {
            XCTFail("Invalid thread type")
        }
    }
    
    func testRookFork() throws {
        let board = ChessBoard()
        let analizer = ThreatAnalizer(chessboard: board)
        ChessBoardLoader(chessBoard: board)
            .load(.white, "Ke1 Rd7")
            .load(.black, "Bb7 Kh7")
        let threats = analizer.analize(attackerColor: .white)
        if case .fork(let attacker, let victims) = threats.first {
            XCTAssertEqual(attacker.square, "d7")
            let squares = victims.map { $0.square }
            XCTAssertTrue(squares.contains("b7"))
            XCTAssertTrue(squares.contains("h7"))
        } else {
            XCTFail("Invalid thread type")
        }
    }
    
    func testPin() throws {
        let fen = "r3kb1r/pp1q1ppp/4p3/1B1pP3/4nBb1/1QP5/PP1N1PPP/R3K2R b KQkq - 0 11"
        let board = ChessBoard()
        let analizer = ThreatAnalizer(chessboard: board)
        let loader = FenLoader(boardLoader: ChessBoardLoader(chessBoard: board))
        try loader.load(fen: fen)
        let threats = analizer.analize(attackerColor: .white)
        if case .pin(let attacker, let pinned, let protected) = threats.last {
            XCTAssertEqual(attacker.square, "b5")
            XCTAssertEqual(pinned.square, "d7")
            XCTAssertEqual(protected.square, "e8")
        } else {
            XCTFail("Invalid thread type")
        }
    }
}
