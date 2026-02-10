import Foundation

func generador2() -> String {
    enum Wall: String {
        case U = "U"
        case R = "R"
        case F = "F"
    }

    class Cube {
        var walls: [Wall]

        init() {
            walls = [.U, .R, .F]
        }

        func getRandomWall() -> Wall {
            return walls.randomElement()!
        }
    }

    class Scrambler {
        var numberOfMoves: Int
        var scramble: [String?]
        var prevWall: Wall?
        let modifiers = ["", "'", "2"]

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

    let scrambler = Scrambler(numberOfMoves: 10)
    let cube = Cube()
    scrambler.scramble(cube: cube)
    let scrambleString = scrambler.getScrambleString()
    return scrambleString
}

