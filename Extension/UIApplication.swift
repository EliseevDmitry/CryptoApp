//
//  UIApplication.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 22.12.2024.
//

import Foundation
import SwiftUI

//Эта история скрывает клавиатуру при отсутствии редактирования в TextField
//Решение не эффективное - в консоле куча ошибок

extension UIApplication {
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



