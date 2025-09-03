//
//  ObservationsFactoryTests.swift
//  ChessEngine
//
//  Created by Tomasz on 14/01/2025.
//

import Foundation
@testable import ChessEngine
import XCTest

class ObservationsFactoryTests: MoveTests {
    
    func testBishopFork() throws {
        let board = ChessBoard()
        let analizer = ObservationsFactory(chessboard: board)
        ChessBoardLoader(chessBoard: board)
            .load(.white, "Kb1 a2 b3 c2 Bg4")
            .load(.black, "Kc8 a6 b5 Rh3")
        
        let observations = analizer.analize()
        let fork = ChessObservation.fork(victims: [board["c8"]!, board["h3"]!], attacker: board["g4"]!)
        let check = ChessObservation.check(attackers: [board["g4"]!].set)
        let freePiece = ChessObservation.freePiece(freePiece: board["h3"]!, attacker: board["g4"]!)
        
        XCTAssertEqual(observations[.white]?.count, 3)
        XCTAssertEqual(observations[.white]?.contains(fork), true)
        XCTAssertEqual(observations[.white]?.contains(check), true)
        XCTAssertEqual(observations[.white]?.contains(freePiece), true)
    }
    
    func testNightForkOnKingAndQeen() throws {
        let board = ChessBoard()
        let analizer = ObservationsFactory(chessboard: board)
        ChessBoardLoader(chessBoard: board)
            .load(.white, "Kg2 Qe2 h3 f2 Be1 Rd1 b2 a3")
            .load(.black, "h5 Kg8 g7 Qg6 f7 Nf4 Re8 d5 b6 a5")
        
        let observations = analizer.analize()
        let fork = ChessObservation.fork(victims: [board["e2"]!, board["g2"]!], attacker: board["f4"]!)
        let check = ChessObservation.check(attackers: [board["f4"]!, board["g6"]!].set)
        let freePiece = ChessObservation.freePiece(freePiece: board["e2"]!, attacker: board["f4"]!)
        
        XCTAssertEqual(observations[.black]?.count, 3)
        XCTAssertEqual(observations[.black]?.contains(fork), true)
        XCTAssertEqual(observations[.black]?.contains(check), true)
        XCTAssertEqual(observations[.black]?.contains(freePiece), true)
    }
    
    func testNightTripleFork() throws {
        let board = ChessBoard()
        let analizer = ObservationsFactory(chessboard: board)
        ChessBoardLoader(chessBoard: board)
            .load(.white, "Ka1 a2 b2 Rc1 Nf7")
            .load(.black, "Qd8 Rg5 Kh8")
        
        let observations = analizer.analize()
        let fork = ChessObservation.fork(victims: [board["h8"]!, board["d8"]!, board["g5"]!], attacker: board["f7"]!)
        let check = ChessObservation.check(attackers: [board["f7"]!].set)
        let freePiece = ChessObservation.freePiece(freePiece: board["d8"]!, attacker: board["f7"]!)
        
        XCTAssertEqual(observations[.white]?.count, 3)
        XCTAssertEqual(observations[.white]?.contains(fork), true)
        XCTAssertEqual(observations[.white]?.contains(check), true)
        XCTAssertEqual(observations[.white]?.contains(freePiece), true)
    }
    
    func testPawnFork() throws {
        let board = ChessBoard()
        let analizer = ObservationsFactory(chessboard: board)
        ChessBoardLoader(chessBoard: board)
            .load(.white, "Ra1 a2 Nb1 b2 Bb3 c3 Qd1 d5 Re1 e4 f2 Nf3 Kg1 g2 Bg5 h3")
            .load(.black, "a6 Rb8 Bb6 b5 c7 Nc6 Qd8 d6 Be6 e5 Rf8 f7 Nf6 Kg8 g7 h7")
        
        let observations = analizer.analize()
        let fork = ChessObservation.fork(victims: [board["c6"]!, board["e6"]!], attacker: board["d5"]!)
        let pin = ChessObservation.pinned(pinnedPiece: board["f6"]!, attacker: board["g5"]!, coveredPiece: board["d8"]!)
        let freePiece = ChessObservation.freePiece(freePiece: board["c6"]!, attacker: board["d5"]!)
        
        XCTAssertEqual(observations[.white]?.count, 3)
        XCTAssertEqual(observations[.white]?.contains(fork), true)
        XCTAssertEqual(observations[.white]?.contains(pin), true)
        XCTAssertEqual(observations[.white]?.contains(freePiece), true)
    }
    
    func testRookFork() throws {
        let board = ChessBoard()
        let analizer = ObservationsFactory(chessboard: board)
        ChessBoardLoader(chessBoard: board)
            .load(.white, "Ke1 Rd7")
            .load(.black, "Bb7 Kh7")
        
        let observations = analizer.analize()
        let fork = ChessObservation.fork(victims: [board["b7"]!, board["h7"]!], attacker: board["d7"]!)
        let check = ChessObservation.check(attackers: [board["d7"]!].set)
        let freePiece = ChessObservation.freePiece(freePiece: board["b7"]!, attacker: board["d7"]!)
        XCTAssertEqual(observations[.white]?.count, 3)
        XCTAssertEqual(observations[.white]?.contains(fork), true)
        XCTAssertEqual(observations[.white]?.contains(check), true)
        XCTAssertEqual(observations[.white]?.contains(freePiece), true)
    }
    
    func testPin() throws {
        let fen = "r3kb1r/pp1q1ppp/4p3/1B1pP3/4nBb1/1QP5/PP1N1PPP/R3K2R b KQkq - 0 11"
        let board = ChessBoard()
        let analizer = ObservationsFactory(chessboard: board)
        let loader = FenLoader(boardLoader: ChessBoardLoader(chessBoard: board))
        try loader.load(fen: fen)
        let observations = analizer.analize()
        XCTAssertEqual(observations[.white]?.count, 1)
        XCTAssertEqual(observations[.white]?.first, .pinnedToKing(pinnedPiece: board["d7"]!, attacker: board["b5"]!))
    }
    
    func testFreeBlackPawn() throws {
        let fen = "rnbqkbnr/pppp1ppp/8/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2"
        let board = ChessBoard()
        let loader = FenLoader(boardLoader: ChessBoardLoader(chessBoard: board))
        try loader.load(fen: fen)
        let analizer = ObservationsFactory(chessboard: board)
        let observations = analizer.analize()

        let freePiece = ChessObservation.freePiece(freePiece: board["e5"]!, attacker: board["f3"]!)
        XCTAssertEqual(observations[.white]?.count, 1)
        XCTAssertEqual(observations[.white]?.contains(freePiece), true)
    }
}
