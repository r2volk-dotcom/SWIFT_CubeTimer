


func generadorSq1() -> String {
    let posibles1 = ["0","1","-1","2","-2","3","-3","4","-4","5","-5","6","0"]
    let longitud = Int.random(in: 10...14)
    var escramble = ""
    for _ in 0...longitud{
        let x = Int.random(in: 0...12)
        let y = Int.random(in: 0...12)
        let a = "(\(posibles1[x]),\(posibles1[y]))/"
        escramble = escramble + a
    }
    return String(escramble.dropLast())
}




