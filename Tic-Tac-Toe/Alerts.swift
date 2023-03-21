//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Uchchhwas Roy on 19/3/23.
//

import Foundation
import SwiftUI

struct AlertItem : Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You win"),
                                    message: Text("You are so smart"), buttonTitle: Text("Hell yeah"))
    static let computerWin = AlertItem(title: Text("You lost"),
                                       message: Text("You are so dumb"), buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("Draw"),
                                message: Text("What a battle of wits we have here"), buttonTitle: Text("Try again"))
}
