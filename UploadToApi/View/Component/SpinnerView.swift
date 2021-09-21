//
//  SpinnerView.swift
//  TestUIKIT
//
//  Created by PHONG on 16/09/2021.
//

import SwiftUI

struct SpinnerView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                .fill(Color.black.opacity(0.7))
                .frame(width: 80 , height: 80)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
               
                
        }.frame(maxWidth: .infinity,  maxHeight: .infinity, alignment: .center)
        .background(Color.gray.opacity(0.3))
        .ignoresSafeArea()
    }
}

struct SpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        SpinnerView()
    }
}


