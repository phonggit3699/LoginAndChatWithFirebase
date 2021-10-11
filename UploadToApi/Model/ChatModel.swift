//
//  ChatModel.swift
//  UploadToApi
//
//  Created by PHONG on 08/08/2021.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatModel: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var user: User
    var message: String
    var date: Date
    var seen: Bool
    
    enum CodingKeys: String, CodingKey {
        case user
        case message
        case date
        case seen
    }
}

struct User: Identifiable, Codable, Hashable{
    var id: String
    var name: String
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
