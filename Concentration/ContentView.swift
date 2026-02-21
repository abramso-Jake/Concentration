//
//  ContentView.swift
//  Concentration
//
//  Created by Jake Abramson on 2/15/26.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var totalGuesses = 0
    @State private var gameMessage = ""
    @State private var tiles = ["🚀", "🌶️","🦅","🐢","🦋","🌮","🍕","🦄"]
    @State private var emojiShowing = Array(repeating: false, count: 16)
    @State private var guesses: [Int] = []
    @State private var isDisabled = false
    @State private var success = false
    @State private var playAgain = false
    @State private var audioPlayer: AVAudioPlayer!
    private let tileBlack = "⚪️"
    
    var body: some View {
        VStack {
            Text("Total Guesses: \(totalGuesses)")
                .font(.largeTitle)
                .fontWeight(.black)
            Spacer()
            
            VStack{
                HStack{
                    Button(emojiShowing[0] ? tiles[0] : tileBlack){
                        buttonTapped(num: 0)
                    }
                    Button(emojiShowing[1] ? tiles[1] : tileBlack){
                        buttonTapped(num: 1)
                    }
                    Button(emojiShowing[2] ? tiles[2] : tileBlack){
                        buttonTapped(num: 2)
                    }
                    Button(emojiShowing[3] ? tiles[3] : tileBlack){
                        buttonTapped(num: 3)
                    }
                }
                HStack{
                    Button(emojiShowing[4] ? tiles[4] : tileBlack){
                        buttonTapped(num: 4)
                    }
                    Button(emojiShowing[5] ? tiles[5] : tileBlack){
                        buttonTapped(num: 5)
                    }
                    Button(emojiShowing[6] ? tiles[6] : tileBlack){
                        buttonTapped(num: 6)
                    }
                    Button(emojiShowing[7] ? tiles[7] : tileBlack){
                        buttonTapped(num: 7)
                    }
                }
                HStack{
                    Button(emojiShowing[8] ? tiles[8] : tileBlack){
                        buttonTapped(num: 8)
                    }
                    Button(emojiShowing[9] ? tiles[9] : tileBlack){
                        buttonTapped(num: 9)
                    }
                    Button(emojiShowing[10] ? tiles[10] : tileBlack){
                        buttonTapped(num: 10)
                    }
                    Button(emojiShowing[11] ? tiles[11] : tileBlack){
                        buttonTapped(num: 11)
                    }
                }
                HStack{
                    Button(emojiShowing[12] ? tiles[12] : tileBlack){
                        buttonTapped(num: 12)
                    }
                    Button(emojiShowing[13] ? tiles[13] : tileBlack){
                        buttonTapped(num: 13)
                    }
                    Button(emojiShowing[14] ? tiles[14] : tileBlack){
                        buttonTapped(num: 14)
                    }
                    Button(emojiShowing[15] ? tiles[15] : tileBlack){
                        buttonTapped(num: 15)
                    }
                }
            }
            .font(.largeTitle)
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .controlSize(.large)
            .disabled(isDisabled)
        
            
            Text(gameMessage)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .frame(height: 80)
                
            
            Spacer()
            ZStack{
                Rectangle()
                        .fill(.clear)
                        .frame(height: 80)
                if(isDisabled && !playAgain){
                    Button("Another Try?"){
                        isDisabled = false
                        if (!success) {
                            emojiShowing[guesses[0]] = false
                            emojiShowing[guesses[1]] = false
                        }
                        guesses.removeAll()
                        gameMessage = ""
                    }
                    .font(.title)
                    .buttonStyle(.glassProminent)
                    .tint(success ? .mint : .red)
                } else if (playAgain){
                    Button("Play Again"){
                        isDisabled = false
                        emojiShowing = Array(repeating: false, count: 16)
                        gameMessage = ""
                        flipEmojis()
                        totalGuesses = 0
                        tiles.shuffle()
                        playAgain = false
                        guesses.removeAll()
                    }
                    .font(.title)
                    .buttonStyle(.glassProminent)
                    .tint(.orange)
                   
                }
            }
            
            
        }
        .padding()
        .onAppear{
            tiles = tiles + tiles
            tiles.shuffle()
            print(tiles.joined(separator: ","))
        }
        
    }
    
    func buttonTapped(num: Int) {
        if(!emojiShowing[num]){
            emojiShowing[num] = true
            totalGuesses += 1
            guesses.append(num)
            playSound(soundName: "tile-flip")
        }
        if(totalGuesses % 2 == 0){
            checkForMatch()
            isDisabled = true
        }
    }
    
    func checkForMatch() {
        if(tiles[guesses[0]] == tiles[guesses[1]]){
            gameMessage = "✅ You Found a Match"
            success = true
            playSound(soundName: "correct")
        } else{
            gameMessage = "❌ Not a Match. Try Again."
            success = false
            playSound(soundName: "wrong")
        }
        if (allFlipped()){
            isDisabled = true
            gameMessage = "You Guessed Them All!"
            playAgain = true
            playSound(soundName: "ta-da")
        }
    }
    
    func flipEmojis(){
        for index in 0...emojiShowing.count-1{
            emojiShowing[index] = false
        }
    }
    
    func allFlipped() -> Bool {
        for emoji in emojiShowing{
            if (!emoji){
                return false
            }
        }
        return true
    }
    
    func playSound (soundName: String){
        if audioPlayer != nil && audioPlayer.isPlaying{
            audioPlayer.stop()
        }
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch{
            print("ERROR: \(error.localizedDescription) creating audioPlayer")
        }
    }
    
    
}

#Preview {
    ContentView()
}
