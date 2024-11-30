//
//  DecksViewHandler.swift
//  TranslationApp
//
//  Created by Peter Christian Würdemann on 25.02.23.
//

import Foundation

class DecksViewHandler: ObservableObject{
    @Published var showCreateDeckAlert = false
    @Published var createDeckName = ""
}
