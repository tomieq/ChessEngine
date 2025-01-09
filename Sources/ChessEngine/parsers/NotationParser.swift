//
//  NotationParser.swift
//  chess
//
//  Created by Tomasz Kucharski on 06/08/2024.
//

// NotationParser reads game notation moves and applies them to game

import Foundation

enum NotationParserError: Error {
    case parsingError(String)
}

public class NotationParser {
    private let moveExecutor: ChessMoveExecutor

    public init(moveExecutor: ChessMoveExecutor) {
        self.moveExecutor = moveExecutor
    }
    
    public func split(_ txt: String) -> [String] {
        txt.pgnWithoutComments.replacingOccurrences(of: ".", with: ". ")
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { $0.isEmpty.not }
            .filter { $0.contains(".").not }
            // https://en.wikipedia.org/wiki/Numeric_Annotation_Glyphs#main
            .filter { $0.contains("$").not }
            .map {
                $0.replacingOccurrences(of: "?", with: "")
                    .replacingOccurrences(of: "!", with: "")
            }
    }

    public func process(_ txt: String) throws {
        print("parsing \(txt)")
        let language: Language = txt.contains("H") || txt.contains("S") || txt.contains("W") || txt.contains("G") ? .polish : .english
        let parts = split(txt)
        for part in parts {
            if isFinished(part) { break }
            let command = try parseCastling(part) ?? parseSingleMove(part, language: language)
            moveExecutor.process(command)
        }
    }
    
    private func isFinished(_ part: String) -> Bool {
        if ["1-0", "0-1", "½-½", "0.5-0.5", "*", "+/-", "-/-", "-/+"].contains(part) {
            return true
        }
        return false
    }
    
    private func parseCastling(_ part: String) -> ChessMoveCommand? {
        let color = moveExecutor.chessboard.colorOnMove
        let part = part.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "#", with: "")
        if part == "O-O" || part == "0-0"{
            return .castling(Castling.kingSide(color))
        } else if part == "O-O-O" || part == "0-0-0"{
            return .castling(Castling.queenSide(color))
        }
        return nil
    }

    private func parseSingleMove(_ part: String, language: Language) throws -> ChessMoveCommand {
        var type: ChessPieceType?
        var to: BoardSquare?
        let takes = part.contains("x")
        let part = part.replacingOccurrences(of: "x", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "#", with: "")
        var column: BoardColumn?
        if part.count == 2 {
            // it's a pawn move
            type = .pawn
            to = BoardSquare(stringLiteral: part)
        } else if part.count == 4 {
            // it's a piece move when there is piece letter and source square added
            to = BoardSquare(stringLiteral: part.subString(2, 4))
            type = ChessPieceType.make(letter: part.subString(0, 1), language: language) ?? .pawn
            column = BoardColumn(part.subString(1, 2))
        } else {
            // it's a piece move
            to = BoardSquare(stringLiteral: part.subString(1, 3))
            type = ChessPieceType.make(letter: part.subString(0, 1), language: language) ?? .pawn
        }
        guard let type = type, let to = to else {
            throw NotationParserError.parsingError("Invalid entry \(part)")
        }
        var pieces = moveExecutor.chessboard
            .getPieces(color: moveExecutor.chessboard.colorOnMove)
            .filter { $0.type == type }
            .filter { $0.moveCalculator.possibleMoves.contains(to)}
        if let column = column {
            pieces = pieces.filter { $0.square.column == column }
        }
        guard pieces.count == 1, let piece = pieces.first else {
            throw NotationParserError.parsingError("Ambigious entry \(part)")
        }
        let move = ChessBoardMove(from: piece.square, to: to)
        if piece.type == .pawn, takes, moveExecutor.chessboard[to].isNil {
            let pawn = PawnUtils(square: move.from, color: moveExecutor.chessboard.colorOnMove)
            if let enPassantSquare = (pawn.enPassantSquares.first { $0 == move.to }),
               let takenSquare = enPassantSquare.move(pawn.crawlingDirection.opposite) {
                return .enPassant(move, taken: takenSquare)
            }
        }
        return takes ? .take(move, promotion: nil) : .move(move, promotion: nil)
    }
}
