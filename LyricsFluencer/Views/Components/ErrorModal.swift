//
//  ErrorModal.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 06.11.24.
//
import SwiftUI

struct ErrorModal: View{
    
    @Binding var isErrorModalShown: Bool
    var message: String
    
    var body: some View{
        
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
            Color.black.opacity(0.4).ignoresSafeArea(.all)
        }
        .edgesIgnoringSafeArea(.all)
        
        ZStack{
            VStack{
                Text(message)
                
                SomeSmallButton(text: "Close", buttonAction: {
                    isErrorModalShown = false
                }, textColor: Color.white)
                
            }
            .foregroundColor(Color.white)
        }
    }
}

