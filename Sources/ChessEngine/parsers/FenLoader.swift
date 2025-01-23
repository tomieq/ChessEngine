//
//  FenLoader.swift
//  ChessEngine
//
//  Created by Tomasz on 10/01/2025.
//
import Logger

public enum FenLoaderError: Error {
    case corruptedFen
}

public class FenLoader {
    private let logger = Logger(FenLoader.self)
    private let boardLoader: ChessBoardLoader
    
    public init(boardLoader: ChessBoardLoader) {
        self.boardLoader = boardLoader
    }
    
    public func load(fen: String) throws {
        let fenParts = fen.trimmed.split(" ")
        guard fenParts.count == 6 else {
            logger.e("Corrupted fen: \(fen)")
            throw FenLoaderError.corruptedFen
        }
        boardLoader.chessBoard.removeAllPieces()
        let position = fenParts[0]
        let rows = position.split("/").reversed()
        guard rows.count == 8 else {
            logger.e("Corrupted fen: \(fen)")
            throw FenLoaderError.corruptedFen
        }
        
        // setup position
        for (rowIndex, rowFen) in rows.enumerated() {
            let row = rowIndex.incremented
            var columnIndex = 0
            for letter in rowFen {
                if letter.isNumber {
                    if let emptyNumber = Int("\(letter)") {
                        columnIndex += emptyNumber
                    }
                } else {
                    if let (color, type) = parse(fenLetter: letter),
                       let square = BoardSquare(BoardColumn(rawValue: columnIndex), row) {
                        boardLoader.load(color, "\(type.enLetter)\(square)")
                        columnIndex += 1
                    }
                }
                
            }
        }
        // setup color on move
        let colorOnMove = fenParts[1]
        switch colorOnMove {
        case "w":
            boardLoader.chessBoard.colorOnMove = .white
        case "b":
            boardLoader.chessBoard.colorOnMove = .black
        default:
            logger.e("Corrupted fen: \(fen)")
            throw FenLoaderError.corruptedFen
        }
        logger.i("Loaded fen: \(fen)")
    }
    
    func parse(fenLetter: Character) -> (color: ChessPieceColor, type: ChessPieceType)? {
        switch fenLetter {
        case "p":
            (.black, .pawn)
        case "P":
            (.white, .pawn)
        case "r":
            (.black, .rook)
        case "R":
            (.white, .rook)
        case "n":
            (.black, .knight)
        case "N":
            (.white, .knight)
        case "b":
            (.black, .bishop)
        case "B":
            (.white, .bishop)
        case "k":
            (.black, .king)
        case "K":
            (.white, .king)
        case "q":
            (.black, .queen)
        case "Q":
            (.white, .queen)
        default: nil
        }
    }
}
