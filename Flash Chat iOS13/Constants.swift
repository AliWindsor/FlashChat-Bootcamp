//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Alicia Windsor on 22/02/2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import Foundation

struct k {
    static let appName = "⚡️FlashChat"
    static let cellIdentifier = "reusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "registerToChat"
    static let loginSegue = "loginToChat"
    
    
    struct BrandColors {
        static let purple = "brandPurple"
        static let lightPurple = "brandLightPurple"
        static let blue = "brandBlue"
        static let lighBlue = "brandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
