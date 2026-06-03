//
//  IncidentRefGenerator.swift
//  NurseyConnect-A2
//
//

import Foundation

func generateRef(date: Date, existingCount: Int) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    let datePart = formatter.string(from: date)
    let number = existingCount + 1
    let numberPart = String(format: "%03d", number)
    return "INC-\(datePart)-\(numberPart)"
}

