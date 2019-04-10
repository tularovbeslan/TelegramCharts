//
//  AABB.swift
//  TelegramCharts
//
//  Created by Alexander Ivlev on 17/03/2019.
//  Copyright © 2019 SIA. All rights reserved.
//

import UIKit

internal struct AABB
{
    internal typealias Date = Column.Date
    internal typealias Value = Double
    
    internal static let empty: AABB = AABB(minDate: 0, maxDate: 0, minValue: 0, maxValue: 0)
    internal let minDate: Date
    internal let maxDate: Date
    internal let minValue: Value
    internal let maxValue: Value
    
    internal let dateInterval: Date
    internal let valueInterval: Value
    
    internal init(minDate: Date, maxDate: Date, minValue: Value, maxValue: Value) {
        self.minDate = minDate
        self.maxDate = maxDate
        self.minValue = minValue
        self.maxValue = maxValue
        
        self.dateInterval = maxDate - minDate
        self.valueInterval = maxValue - minValue
    }

    internal func copyWithIntellectualPadding(date datePadding: Double, value valuePadding: Double) -> AABB {
        let aabb = copyWithPadding(date: datePadding, value: valuePadding)
        let minValue = aabb.calculateValueBegin()
        let maxValue = aabb.calculateValueEnd()
        return AABB(minDate: aabb.minDate, maxDate: aabb.maxDate, minValue: minValue, maxValue: maxValue)
    }
    
    internal func copyWithPadding(date datePadding: Double, value valuePadding: Double) -> AABB {
        let minDate = self.minDate - Date(Double(self.dateInterval) * datePadding)
        let maxDate = self.maxDate + Date(Double(self.dateInterval) * datePadding)
        let minValue = self.minValue - Value(Double(self.valueInterval) * valuePadding)
        let maxValue = self.maxValue + Value(Double(self.valueInterval) * valuePadding)
        return AABB(minDate: minDate, maxDate: maxDate, minValue: minValue, maxValue: maxValue)
    }
    
    internal func calculateUIPoint(date: Date, value: Value, rect: CGRect) -> CGPoint {
        let xScale = rect.width / CGFloat(dateInterval)
        let yScale = rect.height / CGFloat(valueInterval)
        
        return CGPoint(x: rect.minX + CGFloat(date - minDate) * xScale,
                       y: rect.maxY - CGFloat(value - minValue) * yScale)
    }
    
    internal func calculateDate(x: CGFloat, rect: CGRect) -> Date {
        let x = max(rect.minX, min(x, rect.maxX))
        let xScale = Double(dateInterval) / Double(rect.width)
        return minDate + Column.Date(round(Double(x - rect.minX) * xScale))
    }

    private func calculateValueBegin() -> Value {
        let roundScale = calculateValueRoundScale()
        return minValue - Double(Int64(minValue) % roundScale)
    }

    private func calculateValueEnd() -> Value {
        let roundScale = calculateValueRoundScale()
        return maxValue + Double(roundScale - Int64(maxValue) % roundScale)
    }

    private func calculateValueRoundScale() -> Int64 {
        var interval = maxValue - minValue
        if interval <= 50 {
            return 1
        }

        var scale: Int64 = 10
        while interval >= 500 {
            interval /= 10
            scale *= 10
        }

        return scale
    }
}
