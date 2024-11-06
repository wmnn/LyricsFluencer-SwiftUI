//
//  DeleteAccountButton.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 06.11.24.
//
import SwiftUI

struct DeleteAccountButton: View{
    
    @EnvironmentObject var appContext: AppContext
    @Binding var isDeleteAccountModalPresented: Bool
    
    var body: some View{
        Button {
            isDeleteAccountModalPresented = true
        } label: {
            HStack{
                Text("Delete Account")
                
            }
            .bold()
            .font(.system(size:24))
            .frame(width: 300, height: 20, alignment: .center)
            .foregroundColor(Color.red)
            .padding()
            .background {
                Color("primaryColor")
            }
            .cornerRadius(18)
        }
    }
}

