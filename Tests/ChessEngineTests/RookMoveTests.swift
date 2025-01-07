//
//  RookMoveTests.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation
@testable import ChessEngine
import XCTest

class RookMoveTests: MoveTests {
    
    func testMovesFromA1OnEMptyBoard() throws {
        let rook = Rook(.white, "a1")
        chessBoard.add(rook)
        let basicMoves = possibleMoves(from: rook?.square)
        XCTAssertEqual(basicMoves.count, 14)
        XCTAssertTrue(basicMoves.contains("b1"))
        XCTAssertTrue(basicMoves.contains("h1"))
        XCTAssertTrue(basicMoves.contains("a4"))
        XCTAssertTrue(basicMoves.contains("a8"))
        XCTAssertFalse(basicMoves.contains("b2"))
    }

    func testMovesFromD4OnEMptyBoard() throws {
        let rook = Rook(.white, "d4")
        chessBoard.add(rook)
        let basicMoves = possibleMoves(from: rook?.square)
        XCTAssertEqual(basicMoves.count, 14)
        XCTAssertTrue(basicMoves.contains("d1"))
        XCTAssertTrue(basicMoves.contains("h4"))
        XCTAssertTrue(basicMoves.contains("d3"))
        XCTAssertTrue(basicMoves.contains("a4"))
        XCTAssertFalse(basicMoves.contains("c3"))
        XCTAssertEqual(possibleAttackers(for: "d4"), [])
        XCTAssertEqual(possibleVictims(for: "d4"), [])
    }

    func test_movesOccupiedByOwnArmy() {
        let chessboardLoader = ChessBoardLoader(chessBoard: chessBoard)
        chessboardLoader.load(.white, "Ra1 a2")
        XCTAssertEqual(possibleMoves(from: "a1").count, 7)
        chessboardLoader.load(.white, "Rh1")
        XCTAssertEqual(possibleMoves(from: "a1").count, 6)
        chessboardLoader.load(.black, "g1")
        XCTAssertEqual(possibleVictims(for: "a1").first, "g1")
        XCTAssertEqual(defended(from: "a1").first, "a2")
        XCTAssertEqual(possibleAttackers(for: "d4"), [])
        XCTAssertEqual(possibleVictims(for: "d4"), [])
    }
    
    func test_movesOccupiedByEnemyArmy() {
        let chessboardLoader = ChessBoardLoader(chessBoard: chessBoard)
        chessboardLoader.load(.white, "Rd1")
        XCTAssertEqual(possibleMoves(from: "d1").count, 14)
        chessboardLoader.load(.black, "d3")
        XCTAssertEqual(possibleMoves(from: "d1").count, 9)
        XCTAssertEqual(possibleVictims(for: "d1").first, "d3")
        XCTAssertEqual(possibleAttackers(for: "d1"), [])
    }
    
    func test_support() {
        chessBoard.setupGame()
        XCTAssertEqual(possibleMoves(from: "a1").count, 0)
        XCTAssertEqual(possibleVictims(for: "a1").count, 0)
        XCTAssertEqual(defended(from: "a1"), ["b1", "a2"])
    }

    func test_possibleMovesWhenPinnedByRook() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Re2")
            .load(.black, "Kh8 Re7")
        XCTAssertEqual(possibleMoves(from: "e2").count, 5)
        XCTAssertEqual(possibleVictims(for: "e2"), ["e7"])
        XCTAssertEqual(possibleAttackers(for: "e2"), ["e7"])
    }
    
    func test_possibleMovesWhenPinnedByBishop() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Rd2")
            .load(.black, "Ke8 Ba5")
        XCTAssertEqual(possibleMoves(from: "d2").count, 0)
        XCTAssertEqual(possibleVictims(for: "d2").count, 0)
        XCTAssertEqual(possibleAttackers(for: "d2"), ["a5"])
    }

    func test_defendKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke2 Rd2")
            .load(.black, "Ke8 Qa2")
        let moves = possibleMoves(from: "d2")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("a2"), true)
        XCTAssertEqual(moves.contains("b2"), true)
        XCTAssertEqual(moves.contains("c2"), true)
        XCTAssertEqual(possibleVictims(for: "d2"), ["a2"])
        XCTAssertEqual(possibleAttackers(for: "d2"), ["a2"])
    }
    
    func test_rookIsDefendedByKnight() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kf3 Rd4 Nf5")
            .load(.black, "Ke8 Nb5")
        XCTAssertEqual(defenders(for: "d4"), ["f5"])
        XCTAssertEqual(defended(from: "d4").count, 0)
        XCTAssertEqual(possibleVictims(for: "d4").count, 0)
        XCTAssertEqual(possibleAttackers(for: "d4"), ["b5"])
    }
    
    func test_rookIsmultipleDefended() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kf1 Ba1 Rc3 Rh3 Qg3 Nd1")
            .load(.black, "Ke8 Ne4 Rc7 Rc8")
        XCTAssertEqual(defenders(for: "c3").count, 4)
        XCTAssertEqual(defended(from: "c3"), ["g3"])
        XCTAssertEqual(possibleVictims(for: "c3"), ["c7"])
        XCTAssertEqual(possibleAttackers(for: "c3").count, 3)
    }
    
    func test_pawnDefendsAndAttacks() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 d3 Rc4")
            .load(.black, "Ke8 d5")
        XCTAssertEqual(possibleAttackers(for: "c4"), ["d5"])
        XCTAssertEqual(defenders(for: "c4"), ["d3"])
    }
    
    func test_isDefendedByKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 Rd1 Rf2")
            .load(.black, "Ke8 d5")
        XCTAssertEqual(defenders(for: "f2"), ["e1"])
        XCTAssertEqual(defenders(for: "d1"), ["e1"])
    }
    
    func test_isAttackedByEnemyKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kh1 Rd1 Rf2")
            .load(.black, "Ke1 d5")
        XCTAssertEqual(possibleAttackers(for: "f2"), ["e1"])
        XCTAssertEqual(possibleAttackers(for: "d1"), ["e1"])
    }
    
    func test_kingIsCheckedByQueenTake() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke2 Rb7")
            .load(.black, "Kg8 Qa2 Qb2")
        XCTAssertEqual(possibleMoves(from: "b7"), ["b2"])
    }
    
    func test_kingIsCheckedByQueenBlock() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke2 Rc7")
            .load(.black, "Kg8 Qa2 Qb2")
        XCTAssertEqual(possibleMoves(from: "c7"), ["c2"])
    }

    func test_kingIsCheckedByKnight() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke2 Ra4")
            .load(.black, "Kg8 Nf4")
        XCTAssertEqual(possibleMoves(from: "a4"), ["f4"])
    }
}

