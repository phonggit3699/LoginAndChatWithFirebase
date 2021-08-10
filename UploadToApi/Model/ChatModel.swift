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
    var name: String
    var user: User
    var message: String
    var date: Date
    
    enum CodingKeys: String, CodingKey {
        case name
        case user
        case message
        case date
    }
}

struct User: Identifiable, Codable, Hashable{
    @DocumentID var id: String?
    var name: String
    enum CodingKeys: String, CodingKey {
        case name
    }
}
