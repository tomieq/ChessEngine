//
//  PawnMoveTests.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import XCTest
@testable import ChessEngine

final class PawnMoveTests: MoveTests {
    func test_initialMoves() throws {
        let chessboardLoader = ChessBoardLoader(chessBoard: chessBoard)
        chessboardLoader.load(.white, "c2")
        XCTAssertEqual(possibleMoves(from: "c2"), ["c3", "c4"])
        chessboardLoader.load(.black, "d7")
        XCTAssertEqual(possibleMoves(from: "d7"), ["d6", "d5"])

//        chessboardLoader.load(.black, "f3")
//        moves = sut.possibleMoves(from: "e2")
//        XCTAssertEqual(moves?.passive.count, 2)
//        XCTAssertEqual(moves?.agressive.count, 1)
//
//        chessboardLoader.load(.black, "e3")
//        moves = sut.possibleMoves(from: "e2")
//        XCTAssertEqual(moves?.passive.count, 0)
//        XCTAssertEqual(moves?.agressive.count, 1)
    }
    
    func test_initialMovesBlockedByOwnArmy() throws {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 c2 d2 Rc4 Rd3")
            .load(.black, "Ke8 e7 f7 Be6 Rf5")
        XCTAssertEqual(possibleMoves(from: "c2"), ["c3"])
        XCTAssertEqual(possibleMoves(from: "d2").count, 0)
        XCTAssertEqual(possibleMoves(from: "f7"), ["f6"])
        XCTAssertEqual(possibleMoves(from: "e7").count, 0)
    }
    
    func test_middleMovesBlockedByOwnArmy() throws {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 b4 c4 Rc5 g7")
            .load(.black, "Ke8 f3 g3 Rg2")
        XCTAssertEqual(possibleMoves(from: "b4"), ["b5"])
        XCTAssertEqual(possibleMoves(from: "c4").count, 0)
        XCTAssertEqual(possibleMoves(from: "g7"), ["g8"])
        XCTAssertEqual(possibleMoves(from: "f3"), ["f2"])
        XCTAssertEqual(possibleMoves(from: "g3").count, 0)
    }
    
    func test_pawnDefendsQueen() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 c2 Ra2 Qb3")
            .load(.black, "Ke8 Bd3")
        XCTAssertEqual(possibleMoves(from: "c2"), ["c3", "c4", "d3"])
        XCTAssertEqual(defenders(for: "c2"), ["a2", "b3"])
        XCTAssertEqual(possibleVictims(for: "c2"), ["d3"])
        XCTAssertEqual(defended(from: "c2"), ["b3"])
    }
    
    func test_pawnIsDefendedByKnight() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kf3 d4 Nf5")
            .load(.black, "Ke8 Nb5")
        XCTAssertEqual(defenders(for: "d4"), ["f5"])
        XCTAssertEqual(defended(from: "d4").count, 0)
        XCTAssertEqual(possibleVictims(for: "d4").count, 0)
        XCTAssertEqual(possibleAttackers(for: "d4"), ["b5"])
    }

    func test_pawnIsMultipleDefended() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kf1 Ba1 c3 Rh3 Rg3 Nd1")
            .load(.black, "Ke8 Ne4 Rc7 Rc8")
        XCTAssertEqual(defenders(for: "c3").count, 4)
        XCTAssertEqual(defended(from: "c3").count, 0)
        XCTAssertEqual(possibleVictims(for: "c3").count, 0)
        XCTAssertEqual(possibleAttackers(for: "c3").count, 3)
    }

    func test_exposeKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 d2")
            .load(.black, "Ke8 Qa5")
        XCTAssertEqual(possibleMoves(from: "d2").count, 0)
    }

    func test_guardingKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 e2")
            .load(.black, "Ke8 Qe5")
        XCTAssertEqual(possibleMoves(from: "e2").count, 2)
    }

    func test_defendKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 d2")
            .load(.black, "Ke8 Qc3")
        XCTAssertEqual(possibleMoves(from: "d2").count, 1)
        XCTAssertEqual(possibleVictims(for: "d2"), ["c3"])
    }

    func test_takeEnemyPawn() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 d4 e4")
            .load(.black, "Ke8 e5")
        XCTAssertEqual(possibleMoves(from: "d4"), ["d5", "e5"])
        XCTAssertEqual(possibleVictims(for: "d4"), ["e5"])
        XCTAssertEqual(possibleAttackers(for: "d4"), ["e5"])
        XCTAssertEqual(possibleMoves(from: "e4").count, 0)
    }
    
    func test_pawnDefends() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 d3 c4")
            .load(.black, "Ke8 d5")
        XCTAssertEqual(possibleAttackers(for: "c4"), ["d5"])
        XCTAssertEqual(defenders(for: "c4"), ["d3"])
    }
    
    func test_isDefendedByKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 d2 f2")
            .load(.black, "Ke8 d5")
        XCTAssertEqual(defenders(for: "f2"), ["e1"])
        XCTAssertEqual(defenders(for: "d2"), ["e1"])
    }
    
    func test_isAttackedByEnemyKing() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Kh1 d2 f2")
            .load(.black, "Ke1 d5")
        XCTAssertEqual(possibleAttackers(for: "f2"), ["e1"])
        XCTAssertEqual(possibleAttackers(for: "d2"), ["e1"])
    }

    func test_kingIsCheckedByQueen() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke3 c2")
            .load(.black, "Kg8 Qa3 Qb3")
        let moves = possibleMoves(from: "c2")
        XCTAssertEqual(moves.count, 2)
        XCTAssertTrue(moves.contains("c3"))
        XCTAssertTrue(moves.contains("b3"))
    }
    
    func test_kingIsCheckedByKnight() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1 c2")
            .load(.black, "Kg8 Nd3")
        let moves = possibleMoves(from: "c2")
        XCTAssertEqual(moves.count, 1)
        XCTAssertTrue(moves.contains("d3"))
    }
    
    func test_enPassantMoveWhite1() throws {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ra1 Nb1 Bc1 Qd1 Ke1 Bf1 Ng1 Rh1 a2 b2 c2 d2 f2 g2 h2 e5")
            .load(.black, "Ra8 Bc8 Qd8 Ke8 Bf8 Ng8 Rh8 a7 b7 c7 d7 e7 g7 h7 Nc6 f7")
        chessBoard.colorOnMove = .black
        let factory = ChessMoveCommandFactory(chessboard: chessBoard)
        let command = try factory.make(from: "f7", to: "f5")
        let executor = ChessMoveExecutor(chessboard: chessBoard)
        executor.process(command)
        let moves = possibleMoves(from: "e5")
        XCTAssertEqual(moves.count, 2)
        XCTAssertTrue(moves.contains("e6"))
        XCTAssertTrue(moves.contains("f6"))
        //XCTAssertEqual(possibleAttackers(for: "f5"), ["e5"])
    }
    
    func test_enPassantMoveWhite2() throws {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ra1 Nb1 Bc1 Qd1 Ke1 Bf1 Ng1 Rh1 a2 b2 c2 d2 f2 g2 h2 e5")
            .load(.black, "Ra8 Bc8 Qd8 Ke8 Bf8 Ng8 Rh8 a7 b7 c7 d7 e7 g7 h7 Nc6 f7")
        chessBoard.colorOnMove = .black
        let factory = ChessMoveCommandFactory(chessboard: chessBoard)
        let command = try factory.make(from: "d7", to: "d5")
        let executor = ChessMoveExecutor(chessboard: chessBoard)
        executor.process(command)
        let moves = possibleMoves(from: "e5")
        XCTAssertEqual(moves.count, 2)
        XCTAssertTrue(moves.contains("e6"))
        XCTAssertTrue(moves.contains("d6"))
        //XCTAssertEqual(possibleAttackers(for: "f5"), ["e5"])
    }
}

