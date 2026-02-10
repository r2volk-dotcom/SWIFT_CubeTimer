func generadorSkewb() -> String {
    enum Wall: String {
        case U = "U"
        case R = "R"
        case L = "L"
        case B = "B"
    }

    class Cube {
        var walls: [Wall]

        init() {
            walls = [.U, .R, .L, .B]
        }

        func getRandomWall() -> Wall {
            return walls.randomElement()!
        }
    }

    class Scrambler {
        var numberOfMoves: Int
        var scramble: [String?]
        var prevWall: Wall?
        let modifiers = ["", "'"]

        init(numberOfMoves: Int) {
            self.numberOfMoves = numberOfMoves
            scramble = Array(repeating: nil, count: numberOfMoves)
        }

        func getRandomModifier() -> String {
            return modifiers.randomElement()!
        }

        func scramble(cube: Cube) {
            for i in 0..<numberOfMoves {
                var nextWall = cube.getRandomWall()
                while nextWall == prevWall {
                    nextWall = cube.getRandomWall()
                }
                prevWall = nextWall
                scramble[i] = "\(nextWall.rawValue)\(getRandomModifier())"
            }
        }

        func getScrambleString() -> String {
            return scramble.compactMap { $0 }.joined(separator: " ")
        }
    }

    let scrambler = Scrambler(numberOfMoves: 9)
    let cube = Cube()
    scrambler.scramble(cube: cube)
    let scrambleString = scrambler.getScrambleString()
    return scrambleString
}
