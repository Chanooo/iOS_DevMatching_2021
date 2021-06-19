//
//  Date+.swift
//  K-MOOC
//
//  Created by 김찬우 on 2021/06/19.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let outSdf = DateFormatter()
        outSdf.dateFormat = format
        return outSdf.string(from: self)
    }
}
