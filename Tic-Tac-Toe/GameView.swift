//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Uchchhwas Roy on 19/3/23.
//

import SwiftUI

struct GameView: View {

    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        LazyVGrid(columns: viewModel.colummns) {
            ForEach(0..<9) { i in
                ZStack {
                    GameSquareView()
                    PlayerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "")
                }
                .onTapGesture {
                    viewModel.processPlayerMove(for: i)
                }
            }
        }
        .disabled(viewModel.isGameBoardDisabled)
        .padding()
        .alert(item: $viewModel.alertItem) { item in
            Alert(title: item.title,
                  message: item.message,
                  dismissButton: .default(item.buttonTitle, action: {
                viewModel.resetGame()
            }))
        }
    }

}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameSquareView: View {
    var body: some View {
        Circle()
            .foregroundColor(.red).opacity(0.5)
    }
}

struct PlayerIndicator: View {
    
    var systemImageName: String
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
