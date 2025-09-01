//
//  KnightMoveTests.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import XCTest
@testable import ChessEngine

final class KnightMoveTests: MoveTests {
    
    func test_allMoves() throws {
        ChessBoardLoader(chessBoard: chessBoard).load(.white, "Nd4")
        XCTAssertEqual(possibleMoves(from: "d4").count, 8)
    }

    func test_movesLimitedByOwnArmy() throws {
        ChessBoardLoader(chessBoard: chessBoard).load(.white, "Nd4 e6")
        XCTAssertEqual(possibleMoves(from: "d4").count, 7)
        ChessBoardLoader(chessBoard: chessBoard).load(.white, "b3")
        XCTAssertEqual(possibleMoves(from: "d4").count, 6)
    }

    func test_attacks() throws {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Nd4")
            .load(.black, "b3 e6")
        XCTAssertEqual(possibleVictims(for: "d4").count, 2)
        XCTAssertEqual(possibleMoves(from: "d4").count, 8)
    }
    
    func test_movePinnedByBishop() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Nf2")
            .load(.black, "Bh4")
        XCTAssertEqual(possibleVictims(for: "f2").count, 0)
        XCTAssertEqual(possibleMoves(from: "f2").count, 0)
        XCTAssertEqual(possibleAttackers(for: "f2"), ["h4"])
        let observation = observation(for: "f2")
        XCTAssertEqual(observation, .pinnedToKing(pinnedPiece: chessBoard["f2"]!, attacker: chessBoard["h4"]!))
    }
    
    func test_movePinnedByRook() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Nd1")
            .load(.black, "Ra1")
        XCTAssertEqual(possibleVictims(for: "d1").count, 0)
        XCTAssertEqual(possibleMoves(from: "d1").count, 0)
        XCTAssertEqual(possibleAttackers(for: "d1"), ["a1"])
        let observation = observation(for: "d1")
        XCTAssertEqual(observation, .pinnedToKing(pinnedPiece: chessBoard["d1"]!, attacker: chessBoard["a1"]!))
    }
    
    func test_movePinnedByQueen() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Nd1")
            .load(.black, "Qa1")
        XCTAssertEqual(possibleVictims(for: "d1").count, 0)
        XCTAssertEqual(possibleMoves(from: "d1").count, 0)
        XCTAssertEqual(possibleAttackers(for: "d1"), ["a1"])
    }
    
    func test_knightIsDefendedByKnight() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kf3 Nd4 Nf5")
            .load(.black, "Ke8 Nb5")
        XCTAssertEqual(defenders(for: "d4"), ["f5"])
        XCTAssertEqual(defended(from: "d4").count, 2)
        XCTAssertEqual(possibleVictims(for: "d4"), ["b5"])
        XCTAssertEqual(possibleAttackers(for: "d4"), ["b5"])
    }
    
    func test_queenIsDoubleDefended() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kf1 Ba1 Nc3 Rh3 Rg3 Nd1")
            .load(.black, "Ke8 Ne4 Rc7 Rc8")
        XCTAssertEqual(defenders(for: "c3").count, 4)
        XCTAssertEqual(defended(from: "c3"), ["d1"])
        XCTAssertEqual(possibleVictims(for: "c3"), ["e4"])
        XCTAssertEqual(possibleAttackers(for: "c3").count, 3)
    }
    
    func test_knightIsMultipleDefended() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kf1 Ba1 Nc3 Rf3 Rh3 g3")
            .load(.black, "Ke8 Ne4 Rc6 Rc8 Nc7")
        XCTAssertEqual(defenders(for: "c3").count, 2)
        XCTAssertEqual(defended(from: "c3").count, 0)
        XCTAssertEqual(possibleVictims(for: "c3"), ["e4"])
        XCTAssertEqual(possibleAttackers(for: "c3").count, 2)
    }
    
    func test_pawnDefendsAndAttacks() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 d3 Nc4")
            .load(.black, "Ke8 d5")
        XCTAssertEqual(possibleAttackers(for: "c4"), ["d5"])
        XCTAssertEqual(defenders(for: "c4"), ["d3"])
    }
    
    func test_isDefendedByKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Nd2 Nf2")
            .load(.black, "Ke8 d5")
        XCTAssertEqual(defenders(for: "f2"), ["e1"])
        XCTAssertEqual(defenders(for: "d2"), ["e1"])
    }
    
    func test_isAttackedByEnemyKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kh1 Nd2 Nf2")
            .load(.black, "Ke1 d5")
        XCTAssertEqual(possibleAttackers(for: "f2"), ["e1"])
        XCTAssertEqual(possibleAttackers(for: "d2"), ["e1"])
    }
    
    func test_kingIsCheckedByQueen() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Nc4")
            .load(.black, "Kg8 Qe5")
        let moves = possibleMoves(from: "c4")
        XCTAssertEqual(moves.count, 2)
        XCTAssertTrue(moves.contains("e5"))
        XCTAssertTrue(moves.contains("e3"))
    }
    
    func test_kingIsCheckedByKnight() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Nd4")
            .load(.black, "Kg8 Nf3")
        let moves = possibleMoves(from: "d4")
        XCTAssertEqual(moves.count, 1)
        XCTAssertTrue(moves.contains("f3"))
    }
    
    func test_queenPinnedByBishop() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Qe1 Ke2 Nf2")
            .load(.black, "Bh4")
        let observation = observation(for: "f2")
        XCTAssertEqual(observation, .pinned(pinnedPiece: chessBoard["f2"]!, attacker: chessBoard["h4"]!, coveredPiece: chessBoard["e1"]!))
    }
    
    func test_bishopPinnedByBishop() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Be1 Ke2 Nf2")
            .load(.black, "Bh4")
        XCTAssertNil(observation(for: "f2"))
    }
}

