//
//  ChessBoardTests.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation
@testable import ChessEngine
import XCTest

class ChessBoardTests: XCTestCase {
    func test_addingPieceToGame() {
        let sut = ChessBoard()
        sut.add(Knight(.black, "c6"))

        let piece = sut.piece(at: "c6")
        XCTAssertEqual(piece?.type, .knight)
        XCTAssertEqual(piece?.color, .black)
    }

    func test_addingPawnFromText() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoard: sut)
            .load(.black, "c7 d7 f7")
            .load(.white, "b2")
        XCTAssertEqual(sut.allPieces.count, 4)
        XCTAssertEqual(sut.piece(at: "c7")?.type, .pawn)
        XCTAssertEqual(sut.piece(at: "d7")?.type, .pawn)
        XCTAssertEqual(sut.piece(at: "f7")?.type, .pawn)
        XCTAssertEqual(sut.piece(at: "f7")?.color, .black)
        XCTAssertEqual(sut.piece(at: "b2")?.type, .pawn)
        XCTAssertEqual(sut.piece(at: "b2")?.color, .white)
    }

    func test_addingChessPiecesUsingText() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoard: sut).load(.black, "Ra1 Nb1 Bc1 Qd1 Ke1")
        XCTAssertEqual(sut.allPieces.count, 5)
        XCTAssertEqual(sut.piece(at: "a1")?.type, .rook)
        XCTAssertEqual(sut.piece(at: "b1")?.type, .knight)
        XCTAssertEqual(sut.piece(at: "c1")?.type, .bishop)
        XCTAssertEqual(sut.piece(at: "d1")?.type, .queen)
        XCTAssertEqual(sut.piece(at: "e1")?.type, .king)
    }

    func test_isFree() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoard: sut)
            .load(.black, "c7 d7 f7")
            .load(.white, "b2")
        XCTAssertTrue(sut.isFree("c2"))
        XCTAssertFalse(sut.isFree("c7"))
    }

    func test_pieceRemoval() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoard: sut).load(.black, "c7")
        XCTAssertFalse(sut.isFree("c7"))
        sut.remove("c7")
        XCTAssertTrue(sut.isFree("c7"))
    }
    
    func test_removeMultiple() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoard: sut).load(.white, "d2 e2 f2")
        XCTAssertFalse(sut.isFree("d2"))
        XCTAssertFalse(sut.isFree("e2"))
        XCTAssertFalse(sut.isFree("f2"))
        sut.remove("d2", "e2")
        XCTAssertTrue(sut.isFree("d2"))
        XCTAssertTrue(sut.isFree("e2"))
        XCTAssertFalse(sut.isFree("f2"))
    }

    func test_move() {
        let sut = ChessBoard()
        ChessBoardLoader(chessBoard: sut).load(.white, "d2")
        XCTAssertFalse(sut.isFree("d2"))
        sut.move(ChessBoardMove(from: "d2", to: "d3"))
        XCTAssertTrue(sut.isFree("d2"))
        XCTAssertFalse(sut.isFree("d3"))
    }
    
    func test_clone() {
        let original = ChessBoard()
        original.setupGame()
        let fenGeneratorOriginal = FenGenerator(chessboard: original)
        
        let clone = original.clone
        let fenGeneratorClone = FenGenerator(chessboard: clone)
        
        let originalFen = fenGeneratorOriginal.fen
        XCTAssertEqual(originalFen, fenGeneratorClone.fen)
        
        // make move on clone and verify original did not change
        clone.move(ChessBoardMove(from: "d2", to: "d4"))
        XCTAssertTrue(clone.isFree("d2"))
        XCTAssertFalse(clone.isFree("d4"))

        XCTAssertFalse(original.isFree("d2"))
        XCTAssertTrue(original.isFree("d4"))
        XCTAssertNotEqual(originalFen, fenGeneratorClone.fen)
    }
}

