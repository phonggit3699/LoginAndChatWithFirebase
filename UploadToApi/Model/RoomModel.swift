//
//  RoomModel.swift
//  UploadToApi
//
//  Created by PHONG on 03/09/2021.
//

import SwiftUI

struct RoomModel: Identifiable, Codable {
    var id: String
    var listRoom: [RoomDetailModel]
}

struct RoomDetailModel: Codable, Hashable {
    var roomID: String
    var name: String
}

let exRoom: [RoomModel] = [RoomModel(id: "kNrmef6bgaW1Vl1MoFRGXgY8kjL2",
                                     listRoom: [RoomDetailModel(roomID: "roomtestA", name: "Phong"),
                                                RoomDetailModel(roomID: "roomtestB", name: "Phong Pham")
                                     ]),
                           RoomModel(id: "U6ggbX6u9VPtyb8Cr4FIl3qW9Ih1",
                                     listRoom: [RoomDetailModel(roomID: "roomtestB", name: "Pham Phong"),
                                                RoomDetailModel(roomID: "roomtestC", name: "Phong")
                                     ]),
                           RoomModel(id: "ZI4CbKHSPeVWqq5qRKc8yzubGFn2",
                                     listRoom: [RoomDetailModel(roomID: "roomtestA", name: "Pham Phong"),
                                                RoomDetailModel(roomID: "roomtestC", name: "Phong Pham")
                                     ])
                        ]





