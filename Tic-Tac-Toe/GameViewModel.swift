//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Uchchhwas Roy on 21/3/23.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let colummns: [GridItem] = [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) == false {
            moves[position] = Move(player: .human, boardIndex: position)
            
            //Check for win condition or draw
            if checkWinCondition(for: .human, in: moves) {
                alertItem = AlertContext.humanWin
                return
            }
            if checkForDraw(in: moves) {
                alertItem = AlertContext.draw
                return
            }
            isGameBoardDisabled = true
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [self] in
                
                let computerPosition = determineComputerMovePosition(in: moves)
                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                isGameBoardDisabled = false
                
                if checkWinCondition(for: .computer, in: moves) {
                    alertItem = AlertContext.computerWin
                    return
                }
                if checkForDraw(in: moves) {
                    alertItem = AlertContext.draw
                    return
                }
            }
        }
    }
    func isSquareOccupied(in moves:[Move?], forIndex index: Int) -> Bool {
        
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    //If AI can win, then win
    //If AI can't win, then block
    //IF AI can't block, then take middle square
    //IF AI can't take middle square, take random available square
    
    func determineComputerMovePosition(in moves:[Move?]) -> Int {
        
        //If AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        let computerMoves = moves.compactMap{ $0 }.filter{$0.player == .computer}
        let computerPositions = Set(computerMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1 {
                let isSquareOccupied = isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isSquareOccupied == false {
                    return winPositions.first!
                }
            }
        }
        
        //If AI can't win, then block
        let humanMoves = moves.compactMap{ $0 }.filter{$0.player == .human}
        let humanPositions = Set(humanMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1 {
                let isSquareOccupied = isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isSquareOccupied == false {
                    return winPositions.first!
                }
            }
        }
        
        //IF AI can't block, then take middle square
        let centerSquare = 4
        if isSquareOccupied(in: moves, forIndex: centerSquare) == false {
            return centerSquare
        }
        
        //IF AI can't take middle square, take random available square
        
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
    
    func resetGame() {
        
        moves = Array(repeating: nil, count: 9)
        isGameBoardDisabled = false
    }
}
