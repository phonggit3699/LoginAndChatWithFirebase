//
//  Extension.swift
//  UploadToApi
//
//  Created by PHONG on 23/09/2021.
//

import SwiftUI

extension View {
    
    public func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
    public var isSmallScreen: Bool {
        return getRect().width <= 375.0
    }
    
    public var textColor: Color{ return Color("mainBg") }
    
    public func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    public func getSafeArea() -> UIEdgeInsets {
        let null = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return null
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return null
        }
        
        return safeArea
    }
    
}



