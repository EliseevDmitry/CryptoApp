//
//  String.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 29.12.2024.
//

import Foundation

extension String {
    //return self.replacingOccurrences(of: "<[^]+>", with: "")
    //убирает метатеги в HTML
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
