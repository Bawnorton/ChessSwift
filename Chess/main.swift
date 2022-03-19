//
//  main.swift
//  Im Bored So I Build Chess
//
//  Created by Benjamin Norton on 6/9/18.
//  Copyright © 2018 Benjamin Norton. All rights reserved.
//

import Foundation

extension StringProtocol {
    var ascii: [UInt32] {
        return unicodeScalars.compactMap { $0.isASCII ? $0.value : nil }
    }
}
extension Character {
    var ascii: UInt32? {
        return String(self).ascii.first
    }
}

let kingMove = [1,7,8,9]
let horseMove = [15,17,10,6]
let rookMove = [1,2,3,4,5,6,7,8,16,24,32,40,48,56]
let bishopMove = [7,9,14,18,21,27,28,35,36,42,45,49,54,56,63]
let queenMove = [1,2,3,4,5,6,7,8,9,14,16,18,21,24,27,28,32,35,36,40,42,45,48,54,56,63]

var wR = [0,8184,6156,6156,8184,6192,6168,6156,0,1]
var wP = [0,8184,6156,6156,8184,6144,6144,6144,0,1]
var wH = [0,6168,6168,6168,8184,6168,6168,6168,0,1]
var wB = [0,8184,6156,6156,8184,6156,6156,8184,0,1]
var wK = [0,6200,6368,7040,7680,7040,6368,6200,0,1]
var wQ = [0,4080,6168,6168,6168,6360,6192,4056,0,1]
let bR = [0,8184,6156,6156,8184,6192,6168,6156,0,0]
let bP = [0,8184,6156,6156,8184,6144,6144,6144,0,0]
let bH = [0,6168,6168,6168,8184,6168,6168,6168,0,0]
let bB = [0,8184,6156,6156,8184,6156,6156,8184,0,0]
let bK = [0,6200,6368,7040,7680,7040,6368,6200,0,0]
let bQ = [0,4080,6168,6168,6168,6360,6192,4056,0,0]
let S = [0,0,0,0,0,0,0,0,0,2]
let C = [0,0,0,0,0,0,0,0,0,3]

var Board = [wR,wH,wB,wK,wQ,wB,wH,wR,
             wP,wP,wP,wP,wP,wP,wP,wP,
             S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,bP,bP,bP,bP,bP,bP,bP,bP,bR,bH,bB,bK,bQ,bB,bH,bR]

var wMovement: String?
var bMovement: String?
var limitedMove = false
var lastTAV = 0
var again = false
var cPresent = false
var turnCounter = true

var left = false
var up = false
var down = false
var right = false
var upRight = false
var downRight = false
var upLeft = false
var downLeft = false

var postMove = false
func checkReset() {
    if turnCounter {
        turnCounter = false
        while true {
            if Board.contains(C) {
                Board.insert(S, at: Board.firstIndex(of: C)!)
                Board.remove(at: Board.firstIndex(of: C)!)
            }
            else {
                break
            }
        }
    }
    else {
        turnCounter = true
    }
}
func reset() {
    left = false
    up = false
    down = false
    right = false
    upRight = false
    downRight = false
    upLeft = false
    downLeft = false
}

func intro() {
    print(" Welcome to Ascii Chess","\n","Developed by Benjamin Norton (OFS Student)", "\n", "", "\n", "Give movement commands by inputing:","\n", "\"Tile with peice you want to move\" to \"Tile where you want to move\"","\n", "Eg. C2 to C4","\n", "","\n", "This is a two player game","\n", "","\n", "")
}
func lines() {
    var b = 0
    while b <= 140 {
        print("-", terminator: "")
        b += 1
    }
    print("")
}
func letters() {
    let alphabet = ["A","B","C","D","E","F","G","H"]
    var i = 0
    print("  |", terminator: "")
    while i <= 7 {
        print("\u{2593}       ", alphabet[i],"      ", terminator: "")
        i += 1
    }
    print("\u{2593}|")
}
func numbers(j: Int, n: Int) {
    if n == 4 {
        print(j + 1, "", terminator: "")
    }
    else if n == 8 {
        print("\u{2593}\u{2593}", terminator: "")
    }
    else {
        print("  ", terminator: "")
    }
}
var condition = true
func getCommand() {
    if condition {
        print("White Move:")
        wMovement = readLine()
        if check(m: wMovement) == false {
            print("Improper Move")
            getCommand()
        }
        else {
            condition = false
        }
    }
    else {
        print("Black Move:")
        bMovement = readLine()
        if check(m: bMovement) == false {
            print("Improper Move")
            getCommand()
        }
        else {
            condition = true
        }
    }
}
func createSquare(square: Int) {
    Board.remove(at: square)
    Board.insert(C, at: square)
    cPresent = true
}
func whichWay(pAV: Int, tAV: Int) -> Bool {
    reset()
    if Board[pAV] == wR || Board[pAV] == bR {
        if tAV < pAV {
            if tAV <= (pAV + 8) {
                up = true
            }
            else {
                left = true
            }
        }
        else {
            if tAV >= (pAV + 8) {
                down = true
            }
            else {
                right = true
            }
        }
    }
    if Board[pAV] == wB || Board[pAV] == bB {
        if tAV < pAV {
            if (pAV - tAV) % 7 == 0 {
                upRight = true
            }
            else {
                upLeft = true
            }
        }
        else {
            if (tAV - pAV) % 7 == 0 {
                downLeft = true
            }
            else {
                downRight = true
            }
        }
    }
    if Board[pAV] == wQ || Board[pAV] == bQ {
        if tAV < pAV {
            if tAV <= (pAV - 8) {
                if (pAV - tAV) % 7 == 0 {
                    upLeft = true
                }
                else if tAV % 9 == 0 {
                    upRight = true
                }
                else {
                    up = true
                }
            }
            else {
                left = true
            }
        }
        else {
            if tAV >= (pAV + 8) {
                if (tAV - pAV) % 7 == 0 {
                    downLeft = true
                }
                else if tAV % 9 == 0 {
                    downRight = true
                }
                else {
                     down = true
                }
            }
            else {
                right = true
            }
        }
    }
    var cantGo: Bool = false
    if left {
        let canGo = (pAV - tAV) % 8
        var i = 0
        while i <= canGo {
            let square = pAV - i
            if Board[square] == S || Board[square] == C {
                cantGo = false
                if again {
                    createSquare(square: square)
                }
            }
            else {
                if postMove && (Board[square] == wK || Board[square] == bK) {
                    break
                }
                cantGo = true
                break
            }
            i += 1
        }
    }
    if right {
        let canGo = (pAV - tAV) % 8
        var i = 1
        while i <= canGo {
            let square = pAV + i
            if Board[square] == S || Board[square] == C {
                cantGo = false
                if again {
                    createSquare(square: square)
                }
            }
            else {
                if postMove && (Board[square] == wK || Board[square] == bK) {
                    break
                }
                cantGo = true
                break
            }
            i += 1
        }
    }
    if up {
        let canGo = (pAV / 8) - (tAV / 8)
        var i = 1
        while i <= canGo {
            let square = pAV - (i * 8)
            if Board[square] == S || Board[square] == C {
                cantGo = false
                if again {
                    createSquare(square: square)
                }
            }
            else {
                if postMove && (Board[square] == wK || Board[square] == bK) {
                    break
                }
                cantGo = true
                break
            }
            i += 1
        }
    }
    if down {
        let canGo = (tAV / 8) - (pAV / 8)
        var i = 1
        while i <= canGo {
            let square = pAV + (i * 8)
            if Board[square] == S || Board[square] == C {
                cantGo = false
                if again {
                    createSquare(square: square)
                }
            }
            else {
                if postMove && (Board[square] == wK || Board[square] == bK) {
                    break
                }
                cantGo = true
                break
            }
            i += 1
        }
    }
    if upLeft {
        let canGo = (pAV / 8) - (tAV / 8)
        var i = 1
        while i <= canGo {
            let square = pAV - (i * 8) - i
            if Board[square] == S || Board[square] == C {
                cantGo = false
                if again {
                    createSquare(square: square)
                }
            }
            else {
                if postMove && (Board[square] == wK || Board[square] == bK) {
                    break
                }
                cantGo = true
                break
            }
            i += 1
        }
    }
    if upRight {
        let canGo = (pAV / 8) - (tAV / 8)
        var i = 1
        while i <= canGo {
            let square = pAV - (i * 8) + i
            if Board[square] == S || Board[square] == C {
                cantGo = false
                if again {
                    createSquare(square: square)
                }
            }
            else {
                if postMove && (Board[square] == wK || Board[square] == bK) {
                    break
                }
                cantGo = true
                break
            }
            i += 1
        }
    }
    if downLeft {
        let canGo = (tAV / 8) - (pAV / 8)
        var i = 1
        while i <= canGo {
            let square = pAV + (i * 8) - i
            if Board[square] == S || Board[square] == C {
                cantGo = false
                if again {
                    createSquare(square: square)
                }
            }
            else {
                if postMove && (Board[square] == wK || Board[square] == bK) {
                    break
                }
                cantGo = true
                break
            }
            i += 1
        }
    }
    if downRight {
        let canGo = (tAV / 8) - (pAV / 8)
        var i = 1
        while i <= canGo {
            let square = pAV + (i * 8) + i
            if Board[square] == S || Board[square] == C {
                cantGo = false
                if again {
                    createSquare(square: square)
                }
            }
            else {
                if postMove && (Board[square] == wK || Board[square] == bK) {
                    break
                }
                cantGo = true
                break
            }
            i += 1
        }
    }
    if cantGo == true {
        return false
    }
    else if postMove && (again == false) {
        again = true
        return whichWay(pAV: pAV, tAV: tAV)
    }
    return true
}
func whichPiece(pAV: Int, tAV: Int) -> Bool {
    if Board[pAV] == wP {
        if tAV <= pAV {
            return false
        }
        if tAV == (pAV + 8) || ((tAV == (pAV + 16) && (pAV <= 15))) {
            if Board[tAV] == S {
                return true
            }
        }
        else if tAV == (pAV + 7) ||  tAV == (pAV + 9) && Board[tAV] != S {
            return true
        }
        return false
        
    }
    if Board[pAV] == bP {
        if pAV <= tAV{
            return false
        }
        if tAV == (pAV - 8) || (tAV == (pAV - 16) && (pAV >= 48)) {
            if Board[tAV] == S {
                return true
            }
        }
        else if tAV == (pAV - 7) ||  tAV == (pAV - 9) && Board[tAV] != S {
            return true
        }
        return false
    }
    if Board[pAV] == wR || Board[pAV] == bR {
        var test = false
        var i = 0
        let n = rookMove.count - 1
        while i <= n {
            if tAV == (pAV + (rookMove[i])) || tAV == (pAV - (rookMove[i])) {
                test = true
                if whichWay(pAV: pAV, tAV: tAV) == false {
                    test = false
                }
            }
            i += 1
        }
        if test == true {
            return true
        }
    }
    if Board[pAV] == wB || Board[pAV] == bB {
        var test = false
        var i = 0
        let n = bishopMove.count - 1
        while i <= n {
            if tAV == (pAV + (bishopMove[i])) || tAV == (pAV - (bishopMove[i])) {
                test = true
                if whichWay(pAV: pAV, tAV: tAV) == false {
                    test = false
                }
            }
            i += 1
        }
        if test == true {
            return true
        }
    }
    if Board[pAV] == wH || Board[pAV] == bH {
        var test = false
        var i = 0
        let n = horseMove.count - 1
        while i <= n {
            if tAV == (pAV + (horseMove[i])) || tAV == (pAV - (horseMove[i])) {
                test = true
            }
            i += 1
        }
        if test == true {
            return true
        }
    }
    if Board[pAV] == bK || Board[pAV] == wK {
        var test = false
        var i = 0
        let n = kingMove.count - 1
        while i <= n {
            if tAV == (pAV + (kingMove[i])) || tAV == (pAV - (kingMove[i])) {
                test = true
            }
            i += 1
        }
        if test == true {
            return true
        }
    }
    if Board[pAV] == bQ || Board[pAV] == wQ {
        var test = false
        var i = 0
        let n = queenMove.count - 1
        while i <= n {
            if tAV == (pAV + (queenMove[i])) || tAV == (pAV - (queenMove[i])) {
                test = true
                if whichWay(pAV: pAV, tAV: tAV) == false {
                    test = false
                }
            }
            i += 1
        }
        if test == true {
            return true
        }
    }
    return false
}
func createLocations(tAV: Int, pAV: Int) -> Bool {
    if (Board[pAV] == wK || Board[pAV] == bK) && Board[tAV] == C {
        return false
    }
    else if (Board[pAV] == wK || Board[pAV] == bK) && Board[tAV] == S {
        return true
    }
    else if Board[tAV] == C {
        return true
    }
    else {
        return false
    }
}
func isMovement(pAV: Int, tAV: Int) -> Bool {
    if pAV == tAV {
        return false
    }
    if Board[pAV] == S {
        return false
    }
    if condition == false  {
        if Board[pAV][9] == 0 {
            return false
        }
    }
    else {
        if Board[pAV][9] == 1 {
            return false
        }
    }
    if limitedMove {
        if createLocations(tAV: tAV, pAV: pAV) == false {
            return false
        }
        else {
            limitedMove = false
        }
    }
    else if whichPiece(pAV: pAV, tAV: tAV) == false  {
        return false
    }
    reset()
    return true
}
func updateBoard() {
    var movement: String
    var takePiece: Bool = true
    if condition {
        movement = bMovement!.replacingOccurrences(of: " ", with: "").uppercased()
    }
    else {
        movement = wMovement!.replacingOccurrences(of: " ", with: "").uppercased()
    }
    let pieceColoumn = Int(movement.prefix(1).ascii[0]) - 64
    let pieceRow = Int(movement[movement.index(movement.startIndex, offsetBy: 1)].ascii!) - 48
    let piecePosition = String(("\(pieceRow)" + "\(pieceColoumn)").replacingOccurrences(of: " ", with: ""))
    let pieceArrayValue = ((Int(piecePosition.prefix(1))! - 1) * 8) + (Int(piecePosition.suffix(1)))! - 1
    let movedPiece = Board[pieceArrayValue]
    let toColoumn = Int(movement[movement.index(movement.startIndex, offsetBy: 4)].ascii!) - 64
    let toRow = Int(movement[movement.index(movement.startIndex, offsetBy: 5)].ascii!) - 48
    let toPosition = String(("\(toRow)" + "\(toColoumn)").replacingOccurrences(of: " ", with: ""))
    let toArrayValue = ((Int(toPosition.prefix(1))! - 1) * 8) + (Int(toPosition.suffix(1)))! - 1
    if isMovement(pAV: pieceArrayValue, tAV: toArrayValue) == false  {
        print("Improper Move")
        if condition {
            condition = false
        }
        else {
            condition = true
        }
        getCommand()
        updateBoard()
        return
    }
    if Board[toArrayValue] != S {
        if Board[toArrayValue] == bK || Board[toArrayValue] == wK {
            takePiece = false
        }
        else if condition == false {
            if Board[toArrayValue][9] == 1 {
                takePiece = false
            }
            else {
                takePiece = true
            }
        }
        else {
            if Board[toArrayValue][9] == 0 {
                takePiece = false
            }
            else {
                takePiece = true
            }
        }
    }
    if takePiece == false {
        print("Improper Move")
        if condition {
            condition = false
        }
        else {
            condition = true
        }
        getCommand()
        updateBoard()
        return
    }
    Board.remove(at: pieceArrayValue)
    Board.insert(S, at: pieceArrayValue)
    Board.remove(at: toArrayValue)
    Board.insert(movedPiece, at: toArrayValue)
    isCheck(pAV: pieceArrayValue, tAV: toArrayValue)
}
func board() {
    var j = 0
    var condition = true
    var r1: String = ""
    var r2: String = ""
    letters()
    lines()
    while j <= 7 {
        var n = 0
        while n <= 8 {
            var i = 0 + (j*8)
            numbers(j: j, n: n)
            print("| ", terminator: "")
            while i <= 7+(j*8) {
                if i >= 64 {
                    break
                }
                else if condition {
                    condition = false
                    r1 = "\u{2593}"
                    r2 = " "
                }
                else {
                    condition = true
                    r2 = "\u{2593}"
                    r1 = " "
                }
                if Board[i][9] == 0 {
                    r2 = "\u{2591}"
                }
                else if Board[i][9] == 1{
                    r2 = "\u{2592}"
                }
                else if Board[i][9] == 3{
                    r2 = "#"
                    r1 = "#"
                }
                let preBinary = ("0000000000000000" + String(Board[i][n], radix: 2)).suffix(16)
                let binary = preBinary.replacingOccurrences(of: "0", with: r1).replacingOccurrences(of: "1", with: r2)
                print(binary,"", terminator: "")
                i += 1
            }
            
            print("|")
            n += 1
        }
        if condition {
            condition = false
        }
        else {
            condition = true
        }
        j += 1
    }
    lines()
    print("")
}
func check(m: String?) -> Bool{
    let alphabet = ["A","B","C","D","E","F","G","H"]
    let numbers = ["1","2","3","4","5","6","7","8"]
    if m == "" || m == nil {
        return false
    }
    let movement = m!.replacingOccurrences(of: " ", with: "").uppercased()
    if movement.count != 6 {
        return false
    }
    if movement.contains("TO") { }
    else {
        return false
    }
    var letterCondition = false
    var letterCondition1 = false
    var numberCondition = false
    var numberCondition1 = false
    var i = 0
    while i <= 7 {
        if movement.prefix(1) == alphabet[i] {
            letterCondition = true
            break
        }
        else {
            letterCondition = false
        }
        i += 1
    }
    i = 0
    while i <= 7 {
        if String(movement[movement.index(movement.startIndex, offsetBy: 4)]) == alphabet[i] {
            letterCondition1 = true
            break
        }
        else {
            letterCondition1 = false
        }
        i += 1
    }
    i = 0
    while i <= 7 {
        if String(movement[movement.index(movement.startIndex, offsetBy: 5)]) == numbers[i] {
            numberCondition = true
            break
        }
        else {
            numberCondition = false
        }
        i += 1
    }
    i = 0
    while i <= 7 {
        if String(movement[movement.index(movement.startIndex, offsetBy: 1)]) == numbers[i] {
            numberCondition1 = true
            break
        }
        else {
            numberCondition1 = false
        }
        i += 1
    }
    if letterCondition == false || letterCondition1 == false || numberCondition == false || numberCondition1 == false {
        return false
    }
    return true
}
func thisIs(piece: Int, whiteKingPosition: Int, blackKingPosition: Int) -> Bool {
    var targetKing: Int
    if condition {
        targetKing = whiteKingPosition
        if Board[piece] == bP {
            if targetKing == piece - 7 || targetKing == piece - 9 {
                return true
            }
        }
        if Board[piece] == bR {
            var test = false
            var i = 0
            let n = rookMove.count - 1
            while i <= n {
                if targetKing == (piece + (rookMove[i])) || targetKing == (piece - (rookMove[i])) {
                    test = true
                    if whichWay(pAV: piece, tAV: targetKing) == false {
                        test = false
                    }
                }
                i += 1
            }
            if test == true {
                return true
            }
        }
        if Board[piece] == bB {
            var test = false
            var i = 0
            let n = bishopMove.count - 1
            while i <= n {
                if targetKing == (piece + (bishopMove[i])) || targetKing == (piece - (bishopMove[i])) {
                    test = true
                    if whichWay(pAV: piece, tAV: targetKing) == false {
                        test = false
                    }
                }
                i += 1
            }
            if test == true {
                return true
            }
        }
        if Board[piece] == bH {
            var test = false
            var i = 0
            let n = horseMove.count - 1
            while i <= n {
                if targetKing == (piece + (horseMove[i])) || targetKing == (piece - (horseMove[i])) {
                    test = true
                }
                i += 1
            }
            if test == true {
                return true
            }
        }
        if Board[piece] == bQ {
            var test = false
            var i = 0
            let n = queenMove.count - 1
            while i <= n {
                if targetKing == (piece + (queenMove[i])) || targetKing == (piece - (queenMove[i])) {
                    test = true
                    if whichWay(pAV: piece, tAV: targetKing) == false {
                        test = false
                    }
                }
                i += 1
            }
            if test == true {
                return true
            }
        }
    }
    else {
        targetKing = blackKingPosition
        if Board[piece] == wP {
            if targetKing == piece + 7 || targetKing == piece + 9 {
                return true
            }
        }
        if Board[piece] == wR {
            var test = false
            var i = 0
            let n = rookMove.count - 1
            while i <= n {
                if targetKing == (piece + (rookMove[i])) || targetKing == (piece - (rookMove[i])) {
                    test = true
                    if whichWay(pAV: piece, tAV: targetKing) == false {
                        test = false
                    }
                }
                i += 1
            }
            if test == true {
                return true
            }
        }
        if Board[piece] == wB {
            var test = false
            var i = 0
            let n = bishopMove.count - 1
            while i <= n {
                if targetKing == (piece + (bishopMove[i])) || targetKing == (piece - (bishopMove[i])) {
                    test = true
                    if whichWay(pAV: piece, tAV: targetKing) == false {
                        test = false
                    }
                }
                i += 1
            }
            if test == true {
                return true
            }
        }
        if Board[piece] == wH {
            var test = false
            var i = 0
            let n = horseMove.count - 1
            while i <= n {
                if targetKing == (piece + (horseMove[i])) || targetKing == (piece - (horseMove[i])) {
                    test = true
                }
                i += 1
            }
            if test == true {
                return true
            }
        }
        if Board[piece] == wQ {
            var test = false
            var i = 0
            let n = queenMove.count - 1
            while i <= n {
                if targetKing == (piece + (queenMove[i])) || targetKing == (piece - (queenMove[i])) {
                    test = true
                    if whichWay(pAV: piece, tAV: targetKing) == false {
                        test = false
                    }
                }
                i += 1
            }
            if test == true {
                return true
            }
        }
    }
    return false
}
func isCheck(pAV: Int, tAV: Int) {
    postMove = true
    var test: Bool = false
    var i = 0
    let n = Board.count
    let wKP = Board.firstIndex(of: wK)!
    let bKP = Board.firstIndex(of: bK)!
    while i <= n {
        let k = i
        if k >= 64 {
            break
        }
        if Board[k][9] == 0 || Board[k][9] == 1 {
            if thisIs(piece: k, whiteKingPosition: wKP, blackKingPosition: bKP) {
                test = true
            }
        }
        i += 1
    }
    if test {
        print("check")
        limitedMove = true
        lastTAV = tAV
    }
}
intro()
board()
while true {
    getCommand()
    reset()
    updateBoard()
    checkReset()
    board()
}
