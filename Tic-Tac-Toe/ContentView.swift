//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Uchchhwas Roy on 19/3/23.
//

import SwiftUI

struct ContentView: View {
    
    let colummns: [GridItem] = [GridItem(.flexible()),
                             GridItem(.flexible()),
                             GridItem(.flexible())]
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameBoardDisabled = false

    var body: some View {
        LazyVGrid(columns: colummns) {
            ForEach(0..<9) { i in
                ZStack {
                    Circle()
                        .foregroundColor(.red).opacity(0.5)
                    Image(systemName: moves[i]?.indicator ?? "")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                    
                }
                .onTapGesture {
                    if isSquareOccupied(in: moves, forIndex: i) == false {
                        moves[i] = Move(player: .human, boardIndex: i)
                        
                        //Check for win condition or draw
                        if checkWinCondition(for: .human, in: moves) {
                            print("Human wins")
                        }
                        if checkForDraw(in: moves) {
                            print("Match drawn")
                        }
                        isGameBoardDisabled = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                            
                            let computerPosition = determineComputerMovePosition(in: moves)
                            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                            isGameBoardDisabled = false
                            
                            if checkWinCondition(for: .computer, in: moves) {
                                print("Computer wins")
                            }
                            if checkForDraw(in: moves) {
                                print("Match drawn")
                            }
                        }
                    }
                }
            }
        }
        .disabled(isGameBoardDisabled)
        .padding()
    }

    func isSquareOccupied(in moves:[Move?], forIndex index: Int) -> Bool {
        
        return moves.contains(where: {$0?.boardIndex == index})
    }

    func determineComputerMovePosition(in moves:[Move?]) -> Int {
        
        var movePostion = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePostion) {
            movePostion = Int.random(in: 0..<9)
        }
        return movePostion
    }
    
    func checkWinCondition (for player: Player, in moves:[Move?]) -> Bool {
        
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        let playerMoves = moves.compactMap{ $0 }.filter{$0.player == player}
        let playerPositions = Set(playerMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns {
            if pattern.isSubset(of: playerPositions){
                return true
            }
        }
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap{ $0 }.count == 9
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
        ContentView()
    }
}
