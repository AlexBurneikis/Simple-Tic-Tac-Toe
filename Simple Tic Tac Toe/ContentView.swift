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
    var boardValues = ["e", "x", "o", "o", "x", "o", "e", "e", "o"]
    
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
            .hidden()
    }
    func makeBoard() ->  some View {
        ZStack {
            Color.black.frame(width: UIScreen.screenWidth / 3.4 * 3, height: UIScreen.screenWidth / 3.4 * 3)
            VStack {
                ForEach(0..<3) {j in
                    HStack {
                        ForEach(0..<3) {i in
                            let topLeft: CGFloat = ((i == 1 && (j == 1 || j == 2)) || (i == 2 && (j == 2 || j == 1)) ? 5 : 0)
                            let topRight: CGFloat = ((i == 1 && (j == 1 || j == 2)) || (i == 0 && (j == 2 || j == 1)) ? 5 : 0)
                            let bottomLeft: CGFloat = ((i == 1 && (j == 1 || j == 0)) || (i == 2 && (j == 0 || j == 1)) ? 5 : 0)
                            let bottomRight: CGFloat = ((i == 1 && (j == 1 || j == 0)) || (i == 0 && (j == 0 || j == 1)) ? 5 : 0)
                            Button {
                                
                            } label: {
                                ZStack {
                                    Color.white
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
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    makeBoard()
                }
                .navigationTitle("Tic Tac Toe")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
