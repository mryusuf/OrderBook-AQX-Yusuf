//
//  Formatter+Ext.swift
//  OrderBook
//
//  Created by Indra Permana on 18/06/23.
//

import Foundation

extension NumberFormatter {
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    static let sizeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        return formatter
    }()
    
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
      }()
    
    static func convertISODateTimeMilliSecDateFormat(from inputDate: Date) -> String {
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "HH:mm:ss"
        return convertDateFormatter.string(from: inputDate)
    }
}
