import XCTest
@testable import ChessEngine

final class KingMoveTests: MoveTests {
    func test_kingPossibleMovesFieldsOccupiedByOwnArmy() throws {
        chessBoard.add(King(.white, "e1"))
        XCTAssertEqual(possibleMoves(from: "e1").count, 5)
        chessBoard.add(Pawn(.white, "e2"))
        XCTAssertEqual(possibleMoves(from: "e1").count, 4)
        chessBoard.add(Pawn(.white, "f2"))
        XCTAssertEqual(possibleMoves(from: "e1").count, 3)
        chessBoard.add(Pawn(.white, "d2"))
        XCTAssertEqual(possibleMoves(from: "e1").count, 2)
        chessBoard.add(Queen(.white, "d1"))
        XCTAssertEqual(possibleMoves(from: "e1").count, 1)
        chessBoard.add(Bishop(.white, "f1"))
        XCTAssertEqual(possibleMoves(from: "e1").count, 0)
    }

    func test_kingCannotApproachEnemyKing() {
        chessBoard.add(King(.white, "d4"))
        XCTAssertEqual(possibleMoves(from: "d4").contains("d5"), true)
        chessBoard.add(King(.black, "d6"))
        XCTAssertEqual(possibleMoves(from: "d4").contains("d5"), false)
    }

    func test_kingCannotGoOnSquareControlledByEnemyRook() {
        ChessBoardLoader(chessBoard: chessBoard).load(.white, "Ke3")
        ChessBoardLoader(chessBoard: chessBoard).load(.black, "Ke8 Rd8 Rf8")
        XCTAssertEqual(possibleMoves(from: "e3").count, 2)
    }
    
    func test_kingCannotGoOnSquareControlledByEnemyKnights() {
        ChessBoardLoader(chessBoard: chessBoard).load(.white, "Ke1")
        ChessBoardLoader(chessBoard: chessBoard).load(.black, "Ke8 Ne4 Nf4")
        XCTAssertEqual(possibleMoves(from: "e1").count, 2)
    }

    func test_kingCannotGoOnSquareControlledByEnemyBishop() {
        ChessBoardLoader(chessBoard: chessBoard).load(.white, "Ke1")
        ChessBoardLoader(chessBoard: chessBoard).load(.black, "Ke8 Bf4 Bg4")
        XCTAssertEqual(possibleMoves(from: "e1").count, 2)
    }
    
    func test_kingCannotGoOnSquareControlledByEnemyPawns() {
        ChessBoardLoader(chessBoard: chessBoard).load(.white, "Ke1")
        ChessBoardLoader(chessBoard: chessBoard).load(.black, "Ke8 e3 f3")
        XCTAssertEqual(possibleMoves(from: "e1").count, 2)
    }
    
    func test_kingCanTakeEnemyPawn() {
        ChessBoardLoader(chessBoard: chessBoard).load(.white, "Ke1")
        ChessBoardLoader(chessBoard: chessBoard).load(.black, "e2 Kh8")
        XCTAssertEqual(possibleMoves(from: "e1").count, 3)
        XCTAssertEqual(possibleVictims(for: "e1"), ["e2"])
        XCTAssertEqual(possibleAttackers(for: "e1").count, 0)
    }
    
    func test_enemyPawnAttackingKing() {
        ChessBoardLoader(chessBoard: chessBoard).load(.white, "Ke1")
        ChessBoardLoader(chessBoard: chessBoard).load(.black, "d2 Kh8")
        XCTAssertEqual(possibleMoves(from: "e1").count, 5)
        XCTAssertEqual(possibleVictims(for: "e1"), ["d2"])
        XCTAssertEqual(possibleAttackers(for: "e1"), ["d2"])
    }

    func test_castlingWhiteKingPossibleMoves() {
        let king = King(.white, "e1")
        let kingSideRook = Rook(.white, "h1")
        let queenSideRook = Rook(.white, "a1")
        chessBoard.add(king, kingSideRook, queenSideRook)
        XCTAssertEqual(possibleMoves(from: "e1").count, 7)
    }
    
    func test_castlingWhiteQueenSidePossibleMove() {
        let king = King(.white, "e1")
        let queenSideRook = Rook(.white, "a1")
        chessBoard.add(king, queenSideRook)
        
        let moves = possibleMoves(from: "e1")
        XCTAssertEqual(moves.count, 6)
        XCTAssertTrue(moves.contains("c1"))
    }

    func test_castlingWhiteKingSidePossibleMove() {
        let king = King(.white, "e1")
        let kingSideRook = Rook(.white, "h1")
        chessBoard.add(king, kingSideRook)

        let moves = possibleMoves(from: "e1")
        XCTAssertEqual(moves.count, 6)
        XCTAssertTrue(moves.contains("g1"))
    }
    
    func test_castlingBlackKingPossibleMoves() {
        let king = King(.black, "e8")
        let kingSideRook = Rook(.black, "h8")
        let queenSideRook = Rook(.black, "a8")
        chessBoard.add(king, kingSideRook, queenSideRook)
        XCTAssertEqual(possibleMoves(from: "e8").count, 7)
    }

    func test_castlingBlackQueenSidePossibleMove() {
        let king = King(.black, "e8")
        let queenSideRook = Rook(.black, "a8")
        chessBoard.add(king, queenSideRook)
        
        let moves = possibleMoves(from: "e8")
        XCTAssertEqual(moves.count, 6)
        XCTAssertTrue(moves.contains("c8"))
    }

    func test_castlingBlackKingSidePossibleMove() {
        let king = King(.black, "e8")
        let kingSideRook = Rook(.black, "h8")
        chessBoard.add(king, kingSideRook)
        
        let moves = possibleMoves(from: "e8")
        XCTAssertEqual(moves.count, 6)
        XCTAssertTrue(moves.contains("g8"))
    }

    func test_movesAtGameStart() {
        chessBoard.setupGame()
        XCTAssertEqual(possibleMoves(from: "e1").count, 0)
        XCTAssertEqual(possibleMoves(from: "e8").count, 0)
    }
    
    func test_whiteQueenSideCastlingBlockedByOwnArmy() {
        ChessBoardLoader(chessBoard: chessBoard).load(.white, "Ra1 Nb1 Ke1 Rh1 d2 e2 f2")
        let moves = possibleMoves(from: "e1")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d1"), true)
        XCTAssertEqual(moves.contains("f1"), true)
        XCTAssertEqual(moves.contains("g1"), true)
    }
    
    func test_whiteKingSideCastlingBlockedByOwnArmy() {
        ChessBoardLoader(chessBoard: chessBoard).load(.white, "Ra1 Ng1 Ke1 Rh1 d2 e2 f2")
        let moves = possibleMoves(from: "e1")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d1"), true)
        XCTAssertEqual(moves.contains("f1"), true)
        XCTAssertEqual(moves.contains("c1"), true)
    }
    
    func test_blackQueenSideCastlingBlockedByOwnArmy() {
        ChessBoardLoader(chessBoard: chessBoard).load(.black, "Ra8 Nb8 Ke8 Rh8 d7 e7 f7")
        let moves = possibleMoves(from: "e8")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d8"), true)
        XCTAssertEqual(moves.contains("f8"), true)
        XCTAssertEqual(moves.contains("g8"), true)
    }
    
    func test_blackKingSideCastlingBlockedByOwnArmy() {
        ChessBoardLoader(chessBoard: chessBoard).load(.black, "Ra8 Ng8 Ke8 Rh8 d7 e7 f7")
        let moves = possibleMoves(from: "e8")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d8"), true)
        XCTAssertEqual(moves.contains("f8"), true)
        XCTAssertEqual(moves.contains("c8"), true)
    }
    
    func test_whiteQueenCastlingBlockedByEnemy() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ra1 Ke1 Rh1 Nf3 d2 e2 f2")
            .load(.black, "Rb5")
        let moves = possibleMoves(from: "e1")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d1"), true)
        XCTAssertEqual(moves.contains("f1"), true)
        XCTAssertEqual(moves.contains("g1"), true)
    }
    
    func test_whiteKingSideCastlingBlockedByEnemy() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ra1 Nd3 Ke1 Rh1 d2 e2 f2")
            .load(.black, "Rg4")
        let moves = possibleMoves(from: "e1")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d1"), true)
        XCTAssertEqual(moves.contains("f1"), true)
        XCTAssertEqual(moves.contains("c1"), true)
    }
    
    func test_blackQueenSideCastlingBlockedByEnemy() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.black, "Ra8 Nf6 Ke8 Rh8 d7 e7 f7")
            .load(.white, "Rb2")
        let moves = possibleMoves(from: "e8")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d8"), true)
        XCTAssertEqual(moves.contains("f8"), true)
        XCTAssertEqual(moves.contains("g8"), true)
    }
    
    func test_blackKingSideCastlingBlockedByEnemy() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.black, "Ra8 Nc6 Ke8 Rh8 d7 e7 f7")
            .load(.white, "Rg2")
        let moves = possibleMoves(from: "e8")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d8"), true)
        XCTAssertEqual(moves.contains("f8"), true)
        XCTAssertEqual(moves.contains("c8"), true)
    }

    func test_kingCantTakeSecuredPawn() {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke1")
            .load(.black, "e2 Ke8 Bb5")
        XCTAssertEqual(possibleMoves(from: "e1").count, 2)
        XCTAssertEqual(possibleVictims(for: "e1"), ["e2"])
        XCTAssertFalse(possibleMoves(from: "e1").contains("e2"))
    }
    
    func test_kingAttackers() throws {
        ChessBoardLoader(chessBoard: chessBoard)
            .load(.white, "Ke2 Bc3")
            .load(.black, "Ke8 Qa2 Qb2")
        XCTAssertEqual(possibleAttackers(for: "e2"), ["b2"])
    }
}

