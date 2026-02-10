
func generador3bld2() -> String {
    let cantidad = Int.random(in: 1...2)
    var rpta = " "
    var giros = [["Rw2", "Rw", "Rw'"], ["Uw2", "Uw", "Uw'"], ["Fw", "Fw'"]]
    
    if cantidad == 1 {
        let a = Int.random(in: 0...7)
        let posibles = ["Rw2", "Rw", "Rw'", "Uw2", "Uw", "Uw'", "Fw", "Fw'"]
        return " \(posibles[a])"
    } else {
        for _ in 0..<2 {
            let x = Int.random(in: 0..<giros.count)
            let girohacer = Int.random(in: 0...1)
            rpta += giros[x][girohacer] + " "
            giros.remove(at: x)
        }
        return rpta
    }
}

func generador3bld() -> String{
    let scramble = (generador3() + generador3bld2())
    return scramble
}
