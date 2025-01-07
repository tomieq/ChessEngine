//
//  ChessBoardLoader.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

public class ChessBoardLoader {
    let chessBoard: ChessBoard
    private let language: Language
    
    public init(chessBoard: ChessBoard, language: Language = .english) {
        self.chessBoard = chessBoard
        self.language = language
    }
    
    // adds pieces to the board parsing the text, e.g.:
    // Ke1 Ra1 Rh1 c2
    @discardableResult
    public func load(_ color: ChessPieceColor, _ txt: String) -> ChessBoardLoader {
        let parts = txt.components(separatedBy: .whitespaces)
        for part in parts {
            if part.count == 2 {
                chessBoard.add(Pawn(color, BoardSquare(stringLiteral: part)))
                continue
            }
            let square = BoardSquare(stringLiteral: part.subString(1, 3))
            guard let type = ChessPieceType.make(letter: part.subString(0, 1), language: language) else {
                continue
            }
            switch type {
            case .king:
                chessBoard.add(King(color, square))
            case .queen:
                chessBoard.add(Queen(color, square))
            case .rook:
                chessBoard.add(Rook(color, square))
            case .bishop:
                chessBoard.add(Bishop(color, square))
            case .knight:
                chessBoard.add(Knight(color, square))
            case .pawn:
                chessBoard.add(Pawn(color, square))
            }
        }
        return self
    }
}
