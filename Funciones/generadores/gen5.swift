
func generador5() -> String {
    enum Wall: String {
        case U = "U"
        case D = "D"
        case R = "R"
        case L = "L"
        case F = "F"
        case B = "B"
    }

    class Cube {
        var walls: [Wall]

        init() {
            walls = [.U, .D, .R, .L, .F, .B]
        }

        func getRandomWall() -> Wall {
            return walls.randomElement()!
        }
    }

    class Scrambler {
        var numberOfMoves: Int
        var scramble: [String?]
        var prevWall: Wall?
        let modifiers = ["", "'", "2","w","w'","w2"]

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

    let scrambler = Scrambler(numberOfMoves: 40)
    let cube = Cube()
    scrambler.scramble(cube: cube)
    let scrambleString = scrambler.getScrambleString()
    return scrambleString
}
