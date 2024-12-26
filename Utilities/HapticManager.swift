//
//  HapticManager.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 27.12.2024.
//

import Foundation
import SwiftUI

//для урощения работы с Haptic эффектами создаем отдельный менеджер
final class HapticManager {
    static private var generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
    
}
