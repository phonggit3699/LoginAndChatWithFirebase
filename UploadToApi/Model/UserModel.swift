//
//  UserModel.swift
//  UploadToApi
//
//  Created by PHONG on 16/08/2021.
//

import Foundation
struct UserModel: Identifiable, Codable {
    var id: String
    var name: String
    var address: String
    var phone: Int
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case phone
    }
}
