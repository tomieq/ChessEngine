//
//  QueenMoveTests.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import XCTest
@testable import ChessEngine

final class QueenMoveTests: MoveTests {
    
    func test_initialMoves() throws {
        let chessboardLoader = ChessBoardLoader(chessBoard: chessBoard)
        chessboardLoader.load(.white, "Qe4")
        XCTAssertEqual(possibleMoves(from: "e4").count, 27)
        XCTAssertEqual(possibleVictims(for: "e4").count, 0)

        chessboardLoader.load(.black, "Re6")
        XCTAssertEqual(possibleMoves(from: "e4").count, 25)
        XCTAssertEqual(possibleVictims(for: "e4").count, 1)
        XCTAssertEqual(possibleAttackers(for: "e4").count, 1)

        chessboardLoader.load(.black, "Ke1")
        XCTAssertEqual(possibleMoves(from: "e4").count, 25)
        XCTAssertEqual(possibleVictims(for: "e4").count, 2)

        chessboardLoader.load(.white, "c2")
        XCTAssertEqual(possibleMoves(from: "e4").count, 23)
        XCTAssertEqual(possibleVictims(for: "e4").count, 2)
    }

    func test_diagonalKingDefence() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Qd2")
            .load(.black, "Ke8 Qa5")
        let moves = possibleMoves(from: "d2")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("c3"), true)
        XCTAssertEqual(moves.contains("b4"), true)
        XCTAssertEqual(possibleVictims(for: "d2"), ["a5"])
    }
    
    func test_queenIsDefendedByKnight() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kf3 Qd4 Nf5")
            .load(.black, "Ke8 Nb5")
        XCTAssertEqual(defenders(for: "d4"), ["f5"])
        XCTAssertEqual(defended(from: "d4").count, 0)
        XCTAssertEqual(possibleVictims(for: "d4").count, 0)
        XCTAssertEqual(possibleAttackers(for: "d4"), ["b5"])
    }
    
    func test_queenIsMultipleDefended() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kf1 Ba1 Qc3 Rh3 Rg3 Nd1")
            .load(.black, "Ke8 Ne4 Rc7 Rc8")
        XCTAssertEqual(defenders(for: "c3").count, 4)
        XCTAssertEqual(defended(from: "c3").count, 2)
        XCTAssertEqual(possibleVictims(for: "c3"), ["c7"])
        XCTAssertEqual(possibleAttackers(for: "c3").count, 3)
    }
    
    func test_isDefendedByKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Qd1 Qf2")
            .load(.black, "Ke8 d5")
        XCTAssertEqual(defenders(for: "f2"), ["e1"])
        XCTAssertEqual(defenders(for: "d1"), ["e1"])
    }
    
    func test_isAttackedByEnemyKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kh1 Qd1 Qf2")
            .load(.black, "Ke1 d5")
        XCTAssertEqual(possibleAttackers(for: "f2"), ["e1"])
        XCTAssertEqual(possibleAttackers(for: "d1"), ["e1"])
    }

    func test_kingIsCheckedByQueen() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke2 Qc3")
            .load(.black, "Ke8 Qa2 Qb2")
        let possibleMoves = possibleMoves(from: "c3")
        XCTAssertEqual(possibleMoves.count, 3)
        XCTAssertTrue(possibleMoves.contains("b2"))
        XCTAssertTrue(possibleMoves.contains("c2"))
        XCTAssertTrue(possibleMoves.contains("d2"))
    }

    func test_kingIsCheckedByKnight() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke2 Qc7")
            .load(.black, "Kg8 Nf4")
        let possibleMoves = possibleMoves(from: "c7")
        XCTAssertEqual(possibleMoves, ["f4"])
    }
}

