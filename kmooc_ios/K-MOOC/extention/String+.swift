//
//  String+.swift
//  K-MOOC
//
//  Created by 김찬우 on 2021/06/19.
//

import Foundation


extension String {
    
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from:self) {
            return date
        } else {
            return Date()
        }
    }
    
    
    
}
