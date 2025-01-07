//
//  String+extension.swift
//
//
//  Created by Tomasz on 04/04/2023.
//

import Foundation

extension String {
    func subString(_ from: Int, _ to: Int) -> String {
        if self.count < to {
            return self
        }

        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(self.startIndex, offsetBy: to)

        let range = start..<end
        return String(self[range])
    }
}

extension String {
    func with(_ elems: CustomStringConvertible...) -> String {
        return String(format: self, arguments: elems.map{ $0.description })
    }
}

extension String {
    func split(_ splitter: String) -> [String] {
        self.components(separatedBy: splitter)
    }
}

extension String {
    func trimming(_ characters: String) -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: characters))
    }

    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
