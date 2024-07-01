//
//  NumberFormatter+Extension.swift
//  CercacorAssignment
//
//  Created by Applanding Solutions on 2024-06-25.
//

import Foundation

extension Double {
    ///Formatter to display double values up to 1 decimal point
    static let decimalValueFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.groupingSeparator = ""
        return formatter
    }()
    
    static let decimalValueInputFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ""
        return formatter
    }()
    
    func format() -> String {
        Self.decimalValueFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    
}
