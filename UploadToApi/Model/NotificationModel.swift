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

struct NotificationModel: Identifiable, Codable, Hashable{
    var id: String
    var title: String
    var message: String
    var seen: Bool
    var type: String
    var time: Date
    var idSend: String
    var isPress: Bool
    var isFriend: Bool
    var imageUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case message
        case seen
        case type
        case time
        case idSend
        case isPress
        case isFriend
        case imageUrl
    }
}
