func generarMega() -> String {
    var scramble = ""
    for _ in 0..<7 {
        scramble += generarmega1() + "\n"
    }
    return scramble
}

func generarmega1() -> String {
    let lista1 = ["R", "D", "R", "D", "R", "D", "R", "D", "R"]
    var lista2 = [String]()
    let l2 = ["--","++"]
    let listaUltimo = [["D--","U'"],["D++","U"]]
    let b = Int.random(in: 0...1)
    for _ in 0..<9 {
        let a = Int.random(in: 0...1)
        lista2.append(l2[a])
    }
    let listaF = zip(lista1, lista2).map { $0 + $1 }
    let listacasi = listaF + listaUltimo[b]
    var linea = ""
    for i in listacasi {
        linea += i + " "
    }
    return linea
}
