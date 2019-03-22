//
//  Configs.swift
//  TelegramCharts
//
//  Created by Alexander Ivlev on 19/03/2019.
//  Copyright © 2019 SIA. All rights reserved.
//

internal enum Configs
{
    internal static let thresholdValueDiff: Double = 0.08 // 8%
    
    internal static let padding: Double = 0.06 // 6%

    internal static let visibleChangeDuration: Double = 0.3

    internal static let intervalChangeForLinesDuration: Double = 0.15
    internal static let intervalChangeForValuesDuration: Double = 0.15
    internal static let intervalChangeForDatesDuration: Double = 0.25

    internal static let hintDuration: Double = 0.25
    
    internal static let minimumPressDuration = 0.05
}
