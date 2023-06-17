//
//  Array+Ext.swift
//  OrderBook
//
//  Created by Indra Permana on 17/06/23.
//

import Foundation

extension Array {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /// Binary Search for index of `Element` with predicate of `isOrderedBefore`.
    func insertionIndexOf(_ elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}

extension Array where Element == OrderBookRowViewModel {
    /// Binary Search for index of `OrderBookData Element` forSide of `OrderBookSide` predicate of `isOrderedBefore`.
    func insertionIndexOf(_ elem: OrderBookData, forSide side: OrderBookSide, isOrderedBefore: (OrderBookData?, OrderBookData?) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(side == .buy ? self[mid].buy : self[mid].sell, elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, side == .buy ? self[mid].buy : self[mid].sell) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}
