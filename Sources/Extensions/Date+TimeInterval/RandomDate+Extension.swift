//
//  File.swift
//  Transactions
//
//  Created by Jean-Nicolas on 07.07.22.
//

import Foundation

extension Date {
    public static var randomDate: Date {
        let calendar = Calendar(identifier: .gregorian)
        let month = Int.random(in: 1...12)
        let day = Int.random(in: 1...28)
        let year = Int.random(in: 1994...2022)
        let dateComponents = DateComponents(year: year, month: month, day: day)
        return calendar.date(from: dateComponents) ?? Date()
    }
}
