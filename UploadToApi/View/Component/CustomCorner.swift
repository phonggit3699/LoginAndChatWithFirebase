//
//  CustomCorner.swift
//  UploadToApi
//
//  Created by PHONG on 10/08/2021.
//

import SwiftUI

struct CustomCorner: Shape {
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        return Path(path.cgPath)
    }
}

