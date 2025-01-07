//
//  Array+extension.swift
//
//
//  Created by Tomasz on 06/04/2023.
//

import Foundation

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}

extension Array where Element: Hashable {
    func commonElements(with other: [Element]) -> [Element] {
        Array(Set(self).intersection(Set(other)))
    }
}
