//
//  ContentView.swift
//  Simple Tic Tac Toe
//
//  Created by Alexander Burneikis on 16/6/2022.
//

import SwiftUI

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var boardValues = ["e", "e", "e", "e", "e", "e", "e", "e", "e"]
    @State var isCrossTurn = true
    @State var winAlert = false
    
    func isSquareFilled(x: Int, y: Int) -> Bool {
        let index = 3 * y + x
        if boardValues[index] != "e" {
            return true
        }
        return false
    }
    func isSquareCross(x: Int, y: Int) -> Bool {
        let index = 3 * y + x
        if boardValues[index] == "x" {
            return true
        }
        return false
    }
    func squareContent(x: Int, y: Int) -> some View {
        if isSquareFilled(x: x, y: y) {
            if isSquareCross(x: x, y: y) {
                return Image(systemName: "xmark")
                    .resizable()
                    .frame(width: UIScreen.screenWidth / 6, height: UIScreen.screenWidth / 6)
                    .foregroundColor(Color.black)
            }
            return Image(systemName: "circle")
                .resizable()
                .frame(width: UIScreen.screenWidth / 5.5, height: UIScreen.screenWidth / 5.5)
                .foregroundColor(Color.black)
        }
        return Image(systemName: "photo")
            .resizable()
            .frame(width: 0, height: 0)
            .foregroundColor(Color.black)
    }
    func updateSquare(x: Int, y: Int) {
        let index = 3 * y + x
        if !isSquareFilled(x: x, y: y) {
            if isCrossTurn {
                boardValues[index] = "x"
                isCrossTurn.toggle()
            }
            else {
                boardValues[index] = "o"
                isCrossTurn.toggle()
            }
        }
    }
    func checkLine(x1: Int, y1: Int, x2: Int, y2: Int, x3: Int, y3: Int) -> Bool {
        if !isSquareFilled(x: x1, y: y1) {
            return false
        }
        if !isSquareFilled(x: x2, y: y2) {
            return false
        }
        if !isSquareFilled(x: x3, y: y3) {
            return false
        }
        if (isSquareCross(x: x1, y: y1) == isSquareCross(x: x2, y: y2)) && (isSquareCross(x: x2, y: y2) == (isSquareCross(x: x3, y: y3))) {
            return true
        }
        return false
    }
    func checkWin() {
        if checkLine(x1: 0, y1: 0, x2: 1, y2: 1, x3: 2, y3: 2) {
            winAlert.toggle()
        }
        //check x=0y=0
        if checkLine(x1: 0, y1: 0, x2: 1, y2: 0, x3: 2, y3: 0) {
            winAlert.toggle()
        }
        if checkLine(x1: 0, y1: 0, x2: 0, y2: 1, x3: 0, y3: 2) {
            winAlert.toggle()
        }
        //check x=1y=1
        if checkLine(x1: 1, y1: 1, x2: 0, y2: 1, x3: 2, y3: 1) {
            winAlert.toggle()
        }
        if checkLine(x1: 1, y1: 1, x2: 1, y2: 0, x3: 1, y3: 2) {
            winAlert.toggle()
        }
        if checkLine(x1: 1, y1: 1, x2: 2, y2: 0, x3: 0, y3: 2) {
            winAlert.toggle()
        }
        //check x=2y=2
        if checkLine(x1: 2, y1: 2, x2: 1, y2: 2, x3: 0, y3: 2) {
            winAlert.toggle()
        }
        if checkLine(x1: 2, y1: 2, x2: 2, y2: 1, x3: 2, y3: 0) {
            winAlert.toggle()
        }
    }
    func makeBoard() ->  some View {
        ZStack {
            Color(colorScheme == .dark ? .white : .black)
                .frame(width: UIScreen.screenWidth / 3.4 * 3, height: UIScreen.screenWidth / 3.4 * 3)
            VStack {
                ForEach(0..<3) {j in
                    HStack {
                        ForEach(0..<3) {i in
                            let topLeft: CGFloat = ((i == 1 && (j == 1 || j == 2)) || (i == 2 && (j == 2 || j == 1)) ? 5 : 0)
                            let topRight: CGFloat = ((i == 1 && (j == 1 || j == 2)) || (i == 0 && (j == 2 || j == 1)) ? 5 : 0)
                            let bottomLeft: CGFloat = ((i == 1 && (j == 1 || j == 0)) || (i == 2 && (j == 0 || j == 1)) ? 5 : 0)
                            let bottomRight: CGFloat = ((i == 1 && (j == 1 || j == 0)) || (i == 0 && (j == 0 || j == 1)) ? 5 : 0)
                            Button {
                                updateSquare(x: i, y: j)
                                checkWin()
                            } label: {
                                ZStack {
                                    Color(colorScheme == .dark ? .black : .white)
                                        .cornerRadius(topLeft, corners: .topLeft)
                                        .cornerRadius(topRight, corners: .topRight)
                                        .cornerRadius(bottomLeft, corners: .bottomLeft)
                                        .cornerRadius(bottomRight, corners: .bottomRight)
                                        .frame(width: UIScreen.screenWidth / 3.4, height: UIScreen.screenWidth / 3.4)
                                    squareContent(x: i, y: j)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func makeScores() -> some View {
        return HStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? .white : .black)
                    .frame(height: 100)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .dark ? .white : .black)
                    .frame(height: 100)
            }
            Spacer()

        }
    }
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    Spacer()
                    makeBoard()
                    Spacer()
                    makeScores()
                }
                .navigationTitle("Tic Tac Toe")
                .toolbar {
                    ToolbarItem {
                        Button {
                            
                        } label: {
                            Text("Reset")
                        }

                    }
                }
                .alert(isPresented: $winAlert) {
                    Alert(
                        title: Text(isCrossTurn ? "o Wins" : "x Wins"),
                        dismissButton: Alert.Button.default(Text("Done")) {
                            boardValues = ["e", "e", "e", "e", "e", "e", "e", "e", "e"]
                        })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
