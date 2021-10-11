//
//  RoomModel.swift
//  UploadToApi
//
//  Created by PHONG on 03/09/2021.
//

import SwiftUI

struct RoomModel: Identifiable, Codable, Hashable{
    var id: String
    var name: String
    var friendId: String
    var roomImgUrl: URL?
}






