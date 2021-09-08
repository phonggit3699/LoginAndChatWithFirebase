//
//  FlexibleSheet.swift
//  UploadToApi
//
//  Created by PHONG on 15/08/2021.
//

import SwiftUI

enum SheetMode {
    case none
    case quarter
    case half
    case full
}

struct FlexibleSheet<Content: View>: View {
    
    let content: () -> Content
    var sheetMode: Binding<SheetMode>
    @Environment(\.colorScheme) var colorScheme
    
    init(sheetMode: Binding<SheetMode>, @ViewBuilder content: @escaping () -> Content) {
        
        self.content = content
        self.sheetMode = sheetMode
        
    }
    
    private func calculateOffset() -> CGFloat {
        
        switch sheetMode.wrappedValue {
        case .none:
            return UIScreen.main.bounds.height
        case .quarter:
            return UIScreen.main.bounds.height - 200
        case .half:
            return UIScreen.main.bounds.height/2
        case .full:
            return 0
        }
        
    }
    
    var body: some View {
        VStack {
            //TODO: top controll
            ZStack {
                Button {
                    if sheetMode.wrappedValue == .half {
                        sheetMode.wrappedValue = .full
                    }
                    else{
                        sheetMode.wrappedValue = .half
                    }
                } label: {
                    if sheetMode.wrappedValue == .full {
                        Image(systemName: "chevron.compact.down")
                            .resizable()
                            .foregroundColor(self.colorScheme == .dark ? Color.white : Color.gray)
                            .frame(width: 40, height: 15)
                    }else{
                        Image(systemName: "chevron.compact.up")
                            .resizable()
                            .foregroundColor(self.colorScheme == .dark ? Color.white : Color.gray)
                            .frame(width: 40, height: 15)
                    }
                }
                
                
                HStack {
                    Button(action: {
                        sheetMode.wrappedValue = .none
                    }, label: {
                        Text("Cancel")
                    })
                    Spacer()
                    
                    Button(action: {
                        sheetMode.wrappedValue = .none
                    }, label: {
                        Text("Done")
                    })
                }.padding(.vertical, 10)
                .padding(.horizontal, 15)
            }
            
            content()
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("darkSheet"))
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        .offset(y: calculateOffset())
        .animation(.default)
    }
}

struct FlexibleSheet_Previews: PreviewProvider {
    static var previews: some View {
        FlexibleSheet(sheetMode: .constant(.none)) {
            VStack {
                Text("Hello World")
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        }
    }
}
