//
//  BishopMoveTests.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation
import XCTest
@testable import ChessEngine

class BishopMoveTests: MoveTests {
    
    func testMovesFromA1() throws {
        let bishop = Bishop(.white, "a1")
        chessBoard.add(bishop)
        let basicMoves = possibleMoves(from: "a1")
        XCTAssertEqual(basicMoves.count, 7)
        XCTAssertTrue(basicMoves.contains("b2"))
        XCTAssertTrue(basicMoves.contains("c3"))
        XCTAssertTrue(basicMoves.contains("g7"))
        XCTAssertTrue(basicMoves.contains("h8"))
        XCTAssertFalse(basicMoves.contains("b1"))
    }

    func testMovesFromH3() throws {
        let bishop = Bishop(.white, "h3")
        chessBoard.add(bishop)
        let basicMoves = possibleMoves(from: "h3")
        XCTAssertEqual(basicMoves.count, 7)
        XCTAssertTrue(basicMoves.contains("g2"))
        XCTAssertTrue(basicMoves.contains("f1"))
        XCTAssertTrue(basicMoves.contains("g4"))
        XCTAssertTrue(basicMoves.contains("c8"))
        XCTAssertFalse(basicMoves.contains("h5"))
    }

    func testMovesFromE5() throws {
        let bishop = Bishop(.white, "e5")
        chessBoard.add(bishop)
        let basicMoves = possibleMoves(from: "e5")
        XCTAssertEqual(basicMoves.count, 13)
        XCTAssertTrue(basicMoves.contains("f6"))
        XCTAssertTrue(basicMoves.contains("f4"))
        XCTAssertTrue(basicMoves.contains("d6"))
        XCTAssertTrue(basicMoves.contains("d4"))
        XCTAssertFalse(basicMoves.contains("d5"))
    }

    func test_movesOccupiedByOwnArmy() {
        let chessboardLoader = ChessBoardLoader(chessBoard: chessBoard)
        chessboardLoader.load(.white, "Be4")
        XCTAssertEqual(possibleMoves(from: "e4").count, 13)
        XCTAssertEqual(possibleVictims(for: "e4").count, 0)

        chessboardLoader.load(.white, "g6")
        XCTAssertEqual(possibleMoves(from: "e4").count, 11)
        XCTAssertEqual(possibleVictims(for: "e4").count, 0)

        chessboardLoader.load(.white, "c6")
        XCTAssertEqual(possibleMoves(from: "e4").count, 8)
        XCTAssertEqual(possibleVictims(for: "e4").count, 0)

        chessboardLoader.load(.white, "f3")
        XCTAssertEqual(possibleMoves(from: "e4").count, 5)
        XCTAssertEqual(possibleVictims(for: "e4").count, 0)

        chessboardLoader.load(.white, "c2")
        XCTAssertEqual(possibleMoves(from: "e4").count, 3)
        XCTAssertEqual(possibleVictims(for: "e4").count, 0)
    }

    func test_movesOccupiedByEnemy() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Bc1")
            .load(.black, "Ra3 Ne3")
        XCTAssertEqual(possibleMoves(from: "c1").count, 4)
        XCTAssertEqual(possibleVictims(for: "c1").count, 2)
    }

    func test_exposeKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke2 Bd2")
            .load(.black, "Ke8 Qa2")
        XCTAssertEqual(possibleMoves(from: "d2").count, 0)
    }

    func test_movesWhenPinnedByQueen() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Bd2")
            .load(.black, "Ke8 Qa5")
        let moves = possibleMoves(from: "d2")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("c3"), true)
        XCTAssertEqual(moves.contains("b4"), true)
        XCTAssertEqual(possibleVictims(for: "d2"), ["a5"])
        XCTAssertEqual(possibleAttackers(for: "d2"), ["a5"])
    }
    
    func test_movesWhenPinnedByRook() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kg4 Bd4 Rd1")
            .load(.black, "Ke8 Rb4")
        XCTAssertEqual(possibleMoves(from: "d4").count, 0)
        XCTAssertEqual(possibleVictims(for: "d4").count, 0)
        XCTAssertEqual(possibleAttackers(for: "d4"), ["b4"])
        XCTAssertEqual(defenders(for: "d4"), ["d1"])
        XCTAssertEqual(defended(from: "d4").count, 0)
    }
    
    func test_bishopIsDefendedByTwoRooks() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Bd2 Ra2 Rh2")
            .load(.black, "Ke8")
        XCTAssertEqual(defenders(for: "d2").count, 3)
        XCTAssertEqual(defended(from: "d2").count, 1)
        XCTAssertEqual(possibleVictims(for: "d2").count, 0)
        XCTAssertEqual(possibleAttackers(for: "d2").count, 0)
    }
    
    func test_bishopIsDefendedByKnight() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kf3 Bd4 Nf5")
            .load(.black, "Ke8 Nb5")
        XCTAssertEqual(defenders(for: "d4"), ["f5"])
        XCTAssertEqual(defended(from: "d4").count, 0)
        XCTAssertEqual(possibleVictims(for: "d4").count, 0)
        XCTAssertEqual(possibleAttackers(for: "d4"), ["b5"])
    }
    
    func test_bishopUnderTripleAttack() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kf1 Bc3")
            .load(.black, "Ke8 Ne4 Rc7 Rc8")
        XCTAssertEqual(defenders(for: "c3").count, 0)
        XCTAssertEqual(defended(from: "c3").count, 0)
        XCTAssertEqual(possibleVictims(for: "c3").count, 0)
        XCTAssertEqual(possibleAttackers(for: "c3").count, 3)
    }
    
    func test_bishopIsTripleDefended() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kf1 Bc3 Rg3 Rh3 Nd1")
            .load(.black, "Ke8 Ne4 Rc7 Rc8")
        XCTAssertEqual(defenders(for: "c3").count, 3)
        XCTAssertEqual(defended(from: "c3").count, 0)
        XCTAssertEqual(possibleVictims(for: "c3").count, 0)
        XCTAssertEqual(possibleAttackers(for: "c3").count, 3)
    }
    
    func test_isDefendedByKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Bd1 Bf2")
            .load(.black, "Ke8 d5")
        XCTAssertEqual(defenders(for: "f2"), ["e1"])
        XCTAssertEqual(defenders(for: "d1"), ["e1"])
    }
    
    func test_isAttackedByEnemyKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kh1 Bd1 Bf2")
            .load(.black, "Ke1 d5")
        XCTAssertEqual(possibleAttackers(for: "f2"), ["e1"])
        XCTAssertEqual(possibleAttackers(for: "d1"), ["e1"])
    }
    
    func test_kingIsCheckedByQueen() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke2 Bc3")
            .load(.black, "Ke8 Qa2 Qb2")
        let possibleMoves = possibleMoves(from: "c3")
        XCTAssertEqual(possibleMoves.count, 2)
        XCTAssertTrue(possibleMoves.contains("b2"))
        XCTAssertTrue(possibleMoves.contains("d2"))
    }

    func test_kingIsCheckedByKnight() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke2 Bc7")
            .load(.black, "Kg8 Nf4")
        let possibleMoves = possibleMoves(from: "c7")
        XCTAssertEqual(possibleMoves, ["f4"])
    }
    
    func test_kingIsCheckedTwice() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke2 Qe3 Nf6")
            .load(.black, "Ra8 Nb8 Bc8 Qd8 Ke8 g7 h7")
        // its double check, so only king can move
        XCTAssertEqual(possibleMoves(from: "a8"), [])
        XCTAssertEqual(possibleMoves(from: "b8"), [])
        XCTAssertEqual(possibleMoves(from: "c8"), [])
        XCTAssertEqual(possibleMoves(from: "d8"), [])
        XCTAssertEqual(possibleMoves(from: "g7"), [])
        XCTAssertEqual(possibleMoves(from: "h7"), [])
    }
}

