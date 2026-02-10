import Foundation

import Foundation

func generador3(longitud: Int = Int.random(in: 19...22)) -> String {
    let movimientos = ["U", "D", "L", "R", "F", "B"]
    let sufijos = ["", "'", "2"]
    let carasOpuestas: [String: String] = [
        "U": "D",
        "D": "U",
        "L": "R",
        "R": "L",
        "F": "B",
        "B": "F"
    ]
    
    func esValido(scramble: [String], movimiento: String) -> Bool {
        if scramble.isEmpty {
            return true
        }
        
        let ultimo = String(scramble.last!.prefix(1)) // Última cara
        if movimiento.prefix(1) == ultimo { // Mismo movimiento consecutivo
            return false
        }
        
        if scramble.count > 1 {
            let penultimo = String(scramble[scramble.count - 2].prefix(1))
            // Evitar combinaciones como F B F o U D U
            if movimiento.prefix(1) == carasOpuestas[ultimo]! && penultimo == ultimo {
                return false
            }
        }
        
        if scramble.count > 2 {
            let antepenultimo = String(scramble[scramble.count - 3].prefix(1))
            // Evitar patrones extendidos como U D U o F B F en tres movimientos
            if movimiento.prefix(1) == antepenultimo && ultimo == carasOpuestas[antepenultimo] {
                return false
            }
        }
        
        return true
    }

    func backtrack(scramble: [String]) -> [String]? {
        if scramble.count == longitud {
            return scramble
        }

        var intentos = 0
        while intentos < 100 { // Limitar intentos por nivel para evitar bucles infinitos
            let movimiento = movimientos.randomElement()! + sufijos.randomElement()!
            if esValido(scramble: scramble, movimiento: movimiento) {
                var nuevoScramble = scramble
                nuevoScramble.append(movimiento)
                if let resultado = backtrack(scramble: nuevoScramble) {
                    return resultado
                }
                // Retroceder si no funciona
                nuevoScramble.removeLast()
            }
            intentos += 1
        }
        
        return nil
    }
    
    if let scramble = backtrack(scramble: []) {
        return scramble.joined(separator: " ")
    } else {
        return "No se pudo generar un scramble válido."
    }
}
