//
//  ContentView.swift
//  RetroNokia
//
//  Created by Vladimir Tanev on 4/6/20.
//  Copyright © 2020 Vladimir Tanev. All rights reserved.
//

import SwiftUI
import Foundation

struct ContentView: View {
    let spacing: CGFloat = 2
    let cellSize: CGFloat = 10
    
    var movesPerSecond: Double { 10 + 0.1 * Double(game.score) }
    
    @State private var game = Snake()
    @State private var lastMove: Snake.Direction = .right
    @State private var timer: Timer? = nil
    
    func playMoveAfterTimeout() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1 / movesPerSecond, repeats: false) { _ in
            self.playMove(self.lastMove)
        }
    }
    
    func playMove(_ direction: Snake.Direction) {
        game.doMove(direction)
        lastMove = direction
        playMoveAfterTimeout()
    }
    
    func replay() {
        lastMove = .right
        game = Snake()
    }   
    
    func colorForCellAt(_ x: Int, _ y: Int) -> Color {
        let position = Snake.Position(x: x, y: y)
        if game.snake.contains(position) { return .snail }
        if game.foodPosition == position { return .food }
        return .background
    }
    
    fileprivate func cellView(_ x: Int, _ y: Int) -> some View {
        return Rectangle().foregroundColor(self.colorForCellAt(x, y))
    }
    
    fileprivate func gameView() -> some View {
        HStack(spacing: self.spacing) {
            ForEach(0..<self.game.size.width) { x in
                VStack(spacing: self.spacing) {
                    ForEach(0..<self.game.size.height) { y in
                        self.cellView(x, y)
                    }
                }
            }
        }
    }
    
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            Image("backPhone")
                .resizable()
                .scaledToFit()
            gameView()
                .frame(width: 225, height: 160, alignment: .center)
                .background(Color.background)
                .offset(y: -90)
                .aspectRatio(contentMode: .fit)
            
            Image("frontPhone")
                .resizable()
                .scaledToFit()
            VStack {
                Spacer()
                ControlsView(
                    upAction: { self.playMove(.up) },
                    downAction: { self.playMove(.down) },
                    leftAction: { self.playMove(.left) },
                    rightAction: { self.playMove(.right) })
                    .onAppear { self.playMoveAfterTimeout() }
            }
            
            Text(".")
            .frame(width: 150, height: 50, alignment: .center)
                .onTapGesture {
                    self.replay()
            }
            
        }
    }
}

struct ControlsView: View {
    let upAction: () -> ()
    let downAction: () -> ()
    let leftAction: () -> ()
    let rightAction: () -> ()
    let width: CGFloat =  70
    let height: CGFloat = 70
    
    var body: some View {
        VStack(alignment: .center, spacing: -10) {
            HStack(spacing: 20) {
                Image("1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                .offset(y: -5)
                Image("2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .offset(y: 5)
                    .animation(.default)
                    .onTapGesture {
                        self.upAction()
                }
                Image("3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                .offset(y: -5)
            }
            
            HStack(spacing: 18)  {
                Image("4")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .offset(y: -15)
                    .animation(.default)

                    .onTapGesture {
                        self.leftAction()
                }
                Image("5")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                Image("6")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .offset(y: -15)
                    .animation(.default)

                    .onTapGesture {
                        self.rightAction()
                }
            }
            HStack(spacing: 16)  {
                Image("7")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .offset(y: -20)
                Image("8")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .offset(y: -15)
                    .animation(.default)

                    .onTapGesture {
                        self.downAction()
                }
                Image("9")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .offset(y: -20)
            }
            HStack(spacing: 16)  {
                Image("*")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                .offset(y: -28)
                Image("0")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                .offset(y: -20)
                Image("#")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                .offset(y: -28)
            }
            
        }
        .aspectRatio(1, contentMode: .fit)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
