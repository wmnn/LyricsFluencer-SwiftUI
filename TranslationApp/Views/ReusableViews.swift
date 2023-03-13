//
//  ViewComponents.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 13.03.23.
//

import SwiftUI


struct SomeHeadline: View{
    var text: String
    var fontSize: CGFloat
    var body: some View{
        Text(text)
            .lineLimit(nil)
            //.fixedSize(horizontal: false, vertical: true)
            .frame(width: 300, alignment: .center)
            .bold()
            .font(.system(size: fontSize))
            .foregroundColor(Color("textColor"))
            .padding()
            .cornerRadius(18)
    }
}
struct ActivityIndicator: View{
    var body: some View{
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .font(.system(size:24))
            .bold()
            .frame(width: 300, height: 20, alignment: .center)
            .foregroundColor(Color("textColor"))
            .padding()
            .background {
                Color("primaryColor")
            }
            .cornerRadius(18)
    }
}

struct SomeButton: View{
    var text: String
    let buttonAction: () -> Void
    var systemName: String?
    
    var body: some View{
        Button {
            buttonAction()
        } label: {
            if systemName == nil {
                TextWithIcon(text: text, systemName: "")
            }else{
                TextWithIcon(text: text, systemName: systemName ?? "")
            }
        }
    }
}
struct SomeButtonWithActivityIndicator: View{
    var text: String
    let buttonAction: () -> Void
    var systemName: String?
    @Binding var binding: Bool
    
    var body: some View{
        Button {
            buttonAction()
        } label: {
            if self.binding{
                ActivityIndicator()
            }else{
                if systemName == nil {
                    TextWithIcon(text: text, systemName: "")
                }else{
                    TextWithIcon(text: text, systemName: systemName!)
                }
            }
        }
    }
}
struct TextWithIcon: View{
    var text: String
    var systemName: String
    var body: some View{
        HStack{
            Text(text)
            Image(systemName: systemName)
        }
        .bold()
        .font(.system(size:24))
        .frame(width: 300, height: 20, alignment: .center)
        .foregroundColor(Color.white)
        .padding()
        .background {
            Color("primaryColor")
        }
        .cornerRadius(18)
        
    }
}
struct SomeTextField: View{
    @Binding var binding: String
    var placeholder: String
    
    var body: some View{
        TextField(text: $binding){
            Text(placeholder).foregroundColor(.gray)
        }
        .font(.system(size:18))
        .frame(width: 300, height: 20, alignment: .center)
        .foregroundColor(Color.black)
        .padding()
        .background {
            Color("inputColor")
        }
        .cornerRadius(18)
        .disableAutocorrection(true)
        .autocapitalization(.none)
    }
}
struct SomeSmallButton: View{
    var text: String
    let buttonAction: () -> Void
    var textColor: Color
    var body: some View{
        Button {
            buttonAction()
        } label: {
            Text(text)
                .font(.system(size:24))
                .bold()
                .frame(width: 120, height: 20, alignment: .center)
                .foregroundColor(textColor)
                .padding()
                .background {
                    Color("primaryColor")
                }
                .cornerRadius(18)

        }
    }
}
