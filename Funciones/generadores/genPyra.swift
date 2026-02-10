
func generadorPyra1() -> String {
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

    let scrambler = Scrambler(numberOfMoves: 8)
    let cube = Cube()
    scrambler.scramble(cube: cube)
    let scrambleString = scrambler.getScrambleString()
    return scrambleString
}

func generadorPyra2() -> String {
    let cantidad = Int.random(in: 0...4)
    var rpta = " "
    var giros = [["u","u'"],["b","b'"],["r","r'"],["l","l'"]]

    if cantidad == 0 {
        return ""
    } else if cantidad == 1 {
        let a = Int.random(in: 0..<8)
        let posibles = ["u","u'","b","b'","r","r'","l","l'"]
        return " " + posibles[a]
    } else if cantidad == 2 {
        for _ in 0..<2 {
            let x = Int.random(in: 0..<giros.count)
            let girohacer = Int.random(in: 0..<2)
            rpta += giros[x][girohacer] + " "
            giros.remove(at: x)
        }
        return rpta
    } else if cantidad == 3 {
        for _ in 0..<3 {
            let x = Int.random(in: 0..<giros.count)
            let girohacer = Int.random(in: 0..<2)
            rpta += giros[x][girohacer] + " "
            giros.remove(at: x)
        }
        return rpta
    } else {
        for _ in 0..<4 {
            let x = Int.random(in: 0..<giros.count)
            let girohacer = Int.random(in: 0..<2)
            rpta += giros[x][girohacer] + " "
            giros.remove(at: x)
        }
        return rpta
    }
}

func generadorPyra() -> String {
    return (generadorPyra1() + generadorPyra2())
}

