//
//  ChessPieceTypeTests.swift
//
//
//  Created by Tomasz on 04/04/2023.
//

import XCTest
@testable import ChessEngine

class ChessPieceTypeTests: XCTestCase {
    func test_creatingTypeFromPolishLetter() {
        XCTAssertEqual(ChessPieceType.make(letter: "K", language: .polish), .king)
        XCTAssertEqual(ChessPieceType.make(letter: "H", language: .polish), .queen)
        XCTAssertEqual(ChessPieceType.make(letter: "S", language: .polish), .knight)
        XCTAssertEqual(ChessPieceType.make(letter: "W", language: .polish), .rook)
        XCTAssertEqual(ChessPieceType.make(letter: "G", language: .polish), .bishop)
    }

    func test_creatingTypeFromEnglishLetter() {
        XCTAssertEqual(ChessPieceType.make(letter: "K", language: .english), .king)
        XCTAssertEqual(ChessPieceType.make(letter: "Q", language: .english), .queen)
        XCTAssertEqual(ChessPieceType.make(letter: "N", language: .english), .knight)
        XCTAssertEqual(ChessPieceType.make(letter: "R", language: .english), .rook)
        XCTAssertEqual(ChessPieceType.make(letter: "B", language: .english), .bishop)
    }
}
