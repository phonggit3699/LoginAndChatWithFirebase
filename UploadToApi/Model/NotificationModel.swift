//
//  NoticationModel.swift
//  UploadToApi
//
//  Created by PHONG on 22/09/2021.
//

import SwiftUI

enum TypeNotification {
    case addFriend
    case normalNotification
}

struct NoticationModel:Identifiable, Codable {
    var id: String
    var content: [NotificationContent]
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
    }
}

struct NotificationContent: Identifiable, Codable{
    var id = UUID().uuidString
    var title: String
    var message: String
    var seen: Bool
    var type: String
    var time: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case message
        case seen
        case type
        case time
    }
}
