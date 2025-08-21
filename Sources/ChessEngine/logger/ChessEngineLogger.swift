//
//  ChessEngineLogger.swift
//  ChessEngine
//
//  Created by Tomasz on 21/08/2025.
//

import Logger

typealias L = ChessEngineLogger
public class ChessEngineLogger {
    nonisolated(unsafe) public static var enabled = true
    let logger: Logger
    
    init(_ tag: Any) {
        self.logger = Logger(tag)
    }
    
    func i(_ msg: @autoclosure () -> CustomStringConvertible) {
        guard Self.enabled else { return }
        logger.i(msg())
    }
    
    func e(_ msg: CustomStringConvertible) {
        logger.e(msg)
    }
}
