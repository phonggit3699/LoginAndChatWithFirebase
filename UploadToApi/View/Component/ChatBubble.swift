//
//  ChatBubble.swift
//  UploadToApi
//
//  Created by PHONG on 10/08/2021.
//

import SwiftUI

struct ChatBubble: Shape {
    var myMsg: Bool
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, myMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        return Path(path.cgPath)
    }
}

