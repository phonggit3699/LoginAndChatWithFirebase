//
//  RoomModel.swift
//  UploadToApi
//
//  Created by PHONG on 03/09/2021.
//

import SwiftUI

struct RoomModel: Identifiable, Codable{
    var id: String
    var listRoom: [RoomDetailModel]
    
    init(id: String, listRoom: [RoomDetailModel]) {
        self.id = id
        self.listRoom = listRoom
    }
}

struct RoomDetailModel: Codable, Hashable {
    var roomID: String
    var name: String
    var friendId: String
    var roomImgUrl: URL?
}

//let exRoom: [RoomModel] = [RoomModel(id: "kNrmef6bgaW1Vl1MoFRGXgY8kjL2",
//                                     listRoom: [RoomDetailModel(roomID: "roomtestA", name: "Phong", roomImgUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/uploadfile-43e92.appspot.com/o/images%2FZI4CbKHSPeVWqq5qRKc8yzubGFn2.jpg?alt=media&token=7ddae068-17a1-4544-8185-b087841a06d1")),
//                                                RoomDetailModel(roomID: "roomtestB", name: "Phong Pham", roomImgUrl: URL(string: "https://graph.facebook.com/2870667646480947/picture"))
//                                     ]),
//                           RoomModel(id: "U6ggbX6u9VPtyb8Cr4FIl3qW9Ih1",
//                                     listRoom: [RoomDetailModel(roomID: "roomtestB", name: "Pham Phong", roomImgUrl: URL(string: "https://lh3.googleusercontent.com/a-/AOh14GjqhiPMnVFXeKf2Eqd-zQna-dhNnY2QXBDvhmlxTw=s96-c")),
//                                                RoomDetailModel(roomID: "roomtestC", name: "Phong", roomImgUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/uploadfile-43e92.appspot.com/o/images%2FZI4CbKHSPeVWqq5qRKc8yzubGFn2.jpg?alt=media&token=7ddae068-17a1-4544-8185-b087841a06d1"))
//                                     ]),
//                           RoomModel(id: "ZI4CbKHSPeVWqq5qRKc8yzubGFn2",
//                                     listRoom: [RoomDetailModel(roomID: "roomtestA", name: "Pham Phong", roomImgUrl: URL(string: "https://lh3.googleusercontent.com/a-/AOh14GjqhiPMnVFXeKf2Eqd-zQna-dhNnY2QXBDvhmlxTw=s96-c")),
//                                                RoomDetailModel(roomID: "roomtestC", name: "Phong Pham", roomImgUrl: URL(string: "https://graph.facebook.com/2870667646480947/picture"))
//                                     ])
//                        ]





