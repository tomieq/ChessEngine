//
//  NotationParser.swift
//  chess
//
//  Created by Tomasz Kucharski on 06/08/2024.
//

// NotationParser reads game notation moves and applies them to game

import Foundation
import Logger

enum NotationParserError: Error {
    case parsingError(String)
}

public class NotationParser {
    private let logger = Logger(NotationParser.self)
    private let moveExecutor: ChessMoveExecutor

    public init(moveExecutor: ChessMoveExecutor) {
        self.moveExecutor = moveExecutor
    }
    
    static public func split(_ txt: String) -> [String] {
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
        logger.i("parsing \(txt)")
        let language: Language = txt.contains("H") || txt.contains("S") || txt.contains("W") || txt.contains("G") ? .polish : .english
        let parts = Self.split(txt)
        for part in parts {
            logger.i("\(moveExecutor.chessboard.colorOnMove) makes move: \(part)")
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
        var promotedType: ChessPieceType?
        var to: BoardSquare?
        let takes = part.contains("x")
        var part = part.replacingOccurrences(of: "x", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "#", with: "")

        if part.contains("="), let letter = part.split("=").last?.last {
            promotedType = ChessPieceType.make(letter: "\(letter)", language: language)
            part = part.replacingOccurrences(of: "=\(letter)", with: "")
        }

        var column: BoardColumn?
        var row: Int?
        if part.count == 2 {
            // it's a pawn move
            type = .pawn
            to = BoardSquare(stringLiteral: part)
        } else if part.count == 4 {
            // it's a piece move when there is piece letter and source square added
            to = BoardSquare(stringLiteral: part.subString(2, 4))
            type = ChessPieceType.make(letter: part.subString(0, 1), language: language) ?? .pawn
            column = BoardColumn(part.subString(1, 2))
            row = Int(part.subString(1, 2))
        } else {
            // it's a piece move
            to = BoardSquare(stringLiteral: part.subString(1, 3))
            type = ChessPieceType.make(letter: part.subString(0, 1), language: language) ?? .pawn
            if type == .pawn {
                column = BoardColumn(part.subString(0, 1))
            }
        }
        guard let type = type, let to = to else {
            throw NotationParserError.parsingError("Invalid entry \(part)")
        }
        var pieces = moveExecutor.chessboard
            .getPieces(color: moveExecutor.chessboard.colorOnMove)
            .filter { $0.type == type }
            .filter { $0.possibleMoves.contains(to)}
        if let column = column {
            pieces = pieces.filter { $0.square.column == column }
        }
        if let row = row {
            pieces = pieces.filter { $0.square.row == row }
        }
        guard pieces.count == 1, let piece = pieces.first else {
            logger.i("white: \(moveExecutor.chessboard.dump(color: .white))")
            logger.i("black: \(moveExecutor.chessboard.dump(color: .black))")
            logger.i("pieces: \(pieces)")
            logger.e("Ambigious entry \(part)")
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
        return takes ? .take(move, promotion: promotedType) : .move(move, promotion: promotedType)
    }
}
