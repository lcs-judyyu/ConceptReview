//
//  GameBoardView.swift
//  NoughtsAndCrosses
//
//  Created by Russell Gordon on 2022-05-03.
//

import SwiftUI

/// - Tag: game_board
struct GameBoardView: View {
    
    // MARK: Stored properties
    
    // Game board state (all nine positions)
    // Top row
    @State var upperLeft = empty
    @State var upperMiddle = empty
    @State var upperRight = empty
    // Middle row
    @State var middleLeft = empty
    @State var middleMiddle = empty
    @State var middleRight = empty
    // Bottom row
    @State var bottomLeft = empty
    @State var bottomMiddle = empty
    @State var bottomRight = empty
    
    // Tracks whose turn it is
    @State var currentPlayer = nought
    
    // Tracks what turn it is (nine total are possible)
    @State var currentTurn = 1
    
    // Tracks whether game is won or not
    @State var gameWon = false
    
    // Tracks whether there is a draw
    @State var draw = false
    
    // Tracks whether should disable changes of the tiles
    @State var disableTileStateChanges = false
    
    // MARK: Computed properties
    var body: some View {
        
        VStack {
            
            Spacer()

            // Current player or who won
            Text("Current player is: \(currentPlayer)")
                // Only show when game is not over
                .opacity(gameWon == false && draw == false ? 1.0 : 0.0)

            ZStack {
                
                Text("\(currentPlayer) wins!")
                    // Only show when game IS over
                    .opacity(gameWon == true ? 1.0 : 0.0)
                
                Text("There is a draw!")
                    // Only show when there's a draw
                    .opacity(draw == true ? 1.0 : 0.0)
                
            }

            Spacer()
            
            // Top row
            HStack {
                // Send connection to properties on this view
                // to the helper view using a binding
                TileView(state: $upperLeft,
                         player: currentPlayer,
                         turn: $currentTurn,
                         disableTiles: $disableTileStateChanges)
                TileView(state: $upperMiddle,
                         player: currentPlayer,
                         turn: $currentTurn,
                         disableTiles: $disableTileStateChanges)
                TileView(state: $upperRight,
                         player: currentPlayer,
                         turn: $currentTurn,
                         disableTiles: $disableTileStateChanges)
            }
            
            // Middle row
            HStack {
                TileView(state: $middleLeft,
                         player: currentPlayer,
                         turn: $currentTurn,
                         disableTiles: $disableTileStateChanges)
                TileView(state: $middleMiddle,
                         player: currentPlayer,
                         turn: $currentTurn,
                         disableTiles: $disableTileStateChanges)
                TileView(state: $middleRight,
                         player: currentPlayer,
                         turn: $currentTurn,
                         disableTiles: $disableTileStateChanges)
            }
            
            // Bottom row
            HStack {
                TileView(state: $bottomLeft,
                         player: currentPlayer,
                         turn: $currentTurn,
                         disableTiles: $disableTileStateChanges)
                TileView(state: $bottomMiddle,
                         player: currentPlayer,
                         turn: $currentTurn,
                         disableTiles: $disableTileStateChanges)
                TileView(state: $bottomRight,
                         player: currentPlayer,
                         turn: $currentTurn,
                         disableTiles: $disableTileStateChanges)
            }
            
            Spacer()

            // Current turn or new game
            Group {
                
                Text("Current turn is: \(currentTurn)")
                    // Only show when game is not over
                    .opacity(gameWon == false && draw == false ? 1.0 : 0.0)
                
                Button(action: {
                    resetGame()
                }, label: {
                    Text("New Game")
                })
                // Only show when game IS over
                .opacity(gameWon == true || draw == true ? 1.0 : 0.0)
                
            }
            
            Spacer()
            
        }
        .onChange(of: currentTurn) { newValue in
            
            print("It's now turn \(newValue), current player is \(currentPlayer)...")

            // Did somebody win?
            checkForWin()
            
            //Is it a draw?
            checkForDraw()
            
        }
        
    }
    
    // MARK: Functions
    
    /// checkForWin
    ///
    /// Looks for all nine win conditions, so long as four turns have occured.
    /// Changes the current player.
    ///
    /// - Tag: winning_condition
    func checkForWin() {
        
        // Only check for win if more than four turns have occured
        if currentTurn > 4 {
            
            // Now check each location
            if
                upperLeft == currentPlayer &&           // Upper row
                upperMiddle == currentPlayer &&
                upperRight == currentPlayer ||
                    
                middleLeft == currentPlayer &&          // Middle row
                middleMiddle == currentPlayer &&
                middleRight == currentPlayer ||
                
                bottomLeft == currentPlayer &&          // Bottom row
                bottomMiddle == currentPlayer &&
                bottomRight == currentPlayer ||
                
                upperLeft == currentPlayer &&           // Left column
                middleLeft == currentPlayer &&
                bottomLeft == currentPlayer ||
                
                upperMiddle == currentPlayer &&         // Middle column
                middleMiddle == currentPlayer &&
                bottomMiddle == currentPlayer ||
                
                upperRight == currentPlayer &&          // Right column
                middleRight == currentPlayer &&
                bottomRight == currentPlayer ||
                
                upperLeft == currentPlayer &&           // Diagonal, left to right
                middleMiddle == currentPlayer &&
                bottomRight == currentPlayer ||
                
                upperRight == currentPlayer &&          // Diagonal, right to left
                middleMiddle == currentPlayer &&
                bottomLeft == currentPlayer
            {
                
                gameWon = true
                print("Game won by \(currentPlayer)...")
                
                disableTileStateChanges = true
                
                // End function now
                return
                
            }
            
        }
        
        // No player won, so change to other player
        if currentPlayer == nought {
            currentPlayer = cross
        } else {
            currentPlayer = nought
        }

    }
    
    func checkForDraw() {
        
        if currentTurn == 10 && gameWon == false {
            draw = true
            disableTileStateChanges = true
        }
        
    }
    
    func resetGame() {
        // Clear game board
        upperLeft = empty
        upperMiddle = empty
        upperRight = empty
        middleLeft = empty
        middleMiddle = empty
        middleRight = empty
        bottomLeft = empty
        bottomMiddle = empty
        bottomRight = empty
        
        // New game, has not been won
        gameWon = false
        
        // Start at first turn
        currentTurn = 1
        
        // Noughts goes first
        currentPlayer = nought
        
        //No draw
        draw = false
        
        //allow state changes for tiles
        disableTileStateChanges = false
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView()
    }
}
