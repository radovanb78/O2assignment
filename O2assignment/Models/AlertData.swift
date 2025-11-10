//
//  AlertData.swift
//  O2assignment
//
//  Created by Radovan Bojkovský on 09/11/2025.
//

import Foundation

struct AlertData: Identifiable {
    let id = UUID()
    var title: String = "Alert"
    let message: String
}
