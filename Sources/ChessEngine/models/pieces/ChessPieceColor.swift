//
//  ChessPieceColor.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

public enum ChessPieceColor: String, CaseIterable {
    case white
    case black
}

extension ChessPieceColor: Sendable {}

extension ChessPieceColor {
    public var other: ChessPieceColor {
        switch self {
        case .white:
            return .black
        case .black:
            return .white
        }
    }
}

extension ChessPieceColor {
    public var plName: String {
        switch self {
        case .white:
            return "biały"
        case .black:
            return "czarny"
        }
    }
    public var enName: String {
        switch self {
        case .white:
            return "white"
        case .black:
            return "black"
        }
    }
    
    var fenLetter: String {
        switch self {
        case .white:
            return "w"
        case .black:
            return "b"
        }
    }
}
