//
//  MoveDirection.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

public enum MoveDirection: CaseIterable {
    case right
    case left
    case up
    case down
    case upRight
    case upLeft
    case downRight
    case downLeft
}

extension MoveDirection {
    var opposite: MoveDirection {
        switch self {
        case .right:
            .left
        case .left:
            .right
        case .up:
            .down
        case .down:
            .up
        case .upRight:
            .downLeft
        case .upLeft:
            .downRight
        case .downRight:
            .upLeft
        case .downLeft:
            .upRight
        }
    }
}


extension MoveDirection {
    var isDiagonal: Bool {
        switch self {
        case .upRight, .upLeft, .downRight, .downLeft:
            true
        default:
            false
        }
    }
    
    static var allDiagonal: [MoveDirection] {
        [.upRight, .upLeft, .downRight, .downLeft]
    }
    
    static var allStraight: [MoveDirection] {
        [.left, .right, .up, .down]
    }
}

