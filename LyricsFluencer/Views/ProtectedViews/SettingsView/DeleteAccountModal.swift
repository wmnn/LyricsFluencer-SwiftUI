//
//  DeleteAccountModal.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 06.11.24.
//
import SwiftUI

struct DeleteAccountModal: View{
    
    @EnvironmentObject var appContext: AppContext
    @EnvironmentObject var userContext: UserContext
    @Binding var isDeleteAccountModalPresented: Bool
    
    var body: some View{
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
            Color.black.opacity(0.4).ignoresSafeArea(.all)
        }
        .edgesIgnoringSafeArea(.all)
        
        ZStack{
            VStack{
                TextWithIcon(text: "Delete Account?", systemName: "")
                HStack{
                    
                    SomeSmallButton(text: "Cancel", buttonAction: {
                        isDeleteAccountModalPresented = false
                    }, textColor: Color.green)
                    
                    SomeSmallButton(text: "Delete", buttonAction: {
                        isDeleteAccountModalPresented = false
                        userContext.handleDelete(appContext: appContext)
                    }, textColor: Color.red)
                    
                    
                }
            }
        }
    }
}
