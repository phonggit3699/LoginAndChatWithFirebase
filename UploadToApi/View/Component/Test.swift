//
//  Test.swift
//  UploadToApi
//
//  Created by PHONG on 06/09/2021.
//

import SwiftUI

struct Test: View {
    @State var showProfile: Bool = false
    @State private var sheetMode: SheetMode = .none
    var body: some View {
        ZStack{
            VStack{
                Text("Hello, World!")
                Button(action: {
                    if sheetMode == .half || sheetMode == .full {
                        sheetMode = .none
                    }else{
                        sheetMode = .half
                    }
                }, label: {
                    Image(systemName: "gearshape")
                        .resizable()
                        .foregroundColor(.blue)
                        .clipShape(Circle())
                        .frame(width: 25, height: 25)
                })
            }
            

        }
        
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
