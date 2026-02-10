let faces = ["R", "L", "U", "D", "F", "B"]

let moves: [String: [String]] = [
    "3x3x3": ["{f}", "{f}'", "{f}2"],
    "4x4x4": ["{f}", "{f}'", "{f}2", "{f}w", "{f}w'", "{f}w2"],
    "5x5x5": ["{f}", "{f}'", "{f}2", "{f}w", "{f}w'", "{f}w2"],
    "6x6x6": ["{f}", "{f}'", "{f}2", "{f}w", "{f}w'", "{f}w2", "3{f}w", "3{f}w'", "3{f}w2"],
    "7x7x7": ["{f}", "{f}'", "{f}2", "{f}w", "{f}w'", "{f}w2", "3{f}w", "3{f}w'", "3{f}w2"]
]

let maxMoves: [String: Int] = [
    "3x3x3": 25,
    "4x4x4": 30,
    "5x5x5": 60,
    "6x6x6": 60,
    "7x7x7": 70
]

let excludeMoves: [String: [String]] = [
    "3x3x3": [],
    "4x4x4": ["Lw", "Lw'", "Lw2", "Dw", "Dw'", "Dw2", "Bw", "Bw'", "Bw2"],
    "5x5x5": [],
    "6x6x6": ["3Lw", "3Lw'", "3Lw2", "3Dw", "3Dw'", "3Dw2", "B3w", "3Bw'", "3Bw2"],
    "7x7x7": []
]

func generateMoves(type: String, excludeFace: String) -> [String] {
    return faces.filter { $0 != excludeFace }.flatMap { face in
        moves[type]!.map { $0.replacingOccurrences(of: "{f}", with: face) }
    }
}

func getRandomMove(type: String, excludeFace: String) -> String {
    let newMoves = generateMoves(type: type, excludeFace: excludeFace)
    return newMoves.randomElement()!
}

func generateScramble(type: String, numMoves: Int) -> [String] {
    guard let maxMoveCount = maxMoves[type] else {
        fatalError("Invalid cube type")
    }

    var scramble = [String]()
    var lastMove = ""

    for _ in 0..<numMoves {
        let excludeFace = scramble.count > 2 ? String(scramble[scramble.count - 3].first!) : ""
        var move = getRandomMove(type: type, excludeFace: excludeFace)

        while move.first == lastMove.first || excludeMoves[type]!.contains(move) {
            move = getRandomMove(type: type, excludeFace: excludeFace)
        }

        lastMove = move
        scramble.append(move)
    }

    return scramble
}

func generar6_7(tamaño: Int) -> String {
    guard tamaño >= 3 && tamaño <= 7 else {
        return ""
    }

    let tipo = "\(tamaño)x\(tamaño)x\(tamaño)"
    guard let numMovimientos = maxMoves[tipo] else {
        return ""
    }

    let mezcla = generateScramble(type: tipo, numMoves: numMovimientos)
    return ("\(mezcla.joined(separator: " "))")
}

