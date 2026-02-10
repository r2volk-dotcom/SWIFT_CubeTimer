
import Foundation

func avg(tiempos:[Double] ,cantidad: Int) -> Double{
    if tiempos.count>cantidad-1{
        var listaAVG = Array(tiempos.suffix(cantidad))
        if let minValue = listaAVG.min(), let maxValue = listaAVG.max() {
            listaAVG.removeAll { $0 == minValue || $0 == maxValue }
        }
        let sumaAVG = listaAVG.reduce(0, +)
        return sumaAVG / Double(cantidad-2)
    }
    else{
        return 0.00
    }
}

func media(tiempos:[Double], cantidad: Int) -> Double {
    var x = 1
    if tiempos.count >= cantidad {
        if !tiempos.isEmpty {
            x = cantidad
        } else {
            x = 1
        }
        let listaM = Array(tiempos.suffix(cantidad))
        return listaM.reduce(0, +) / Double(x)
    } else {
        return 0.0
    }
}

func PBavg(tiempos: [Double],x: Int) -> [Double] {
    guard tiempos.count>x-1 else {
        return [0.0]
    }
    
    var mejorPromedio: Double?
    var mejoresTiempos: [Double]?
    
    for i in 0...(tiempos.count - x) {
        let subTiempos = Array(tiempos[i..<(i + x)])
        let promedio = subTiempos.sorted().dropFirst().dropLast().reduce(0.0, +) / Double(x - 2)
        if mejorPromedio == nil || promedio < mejorPromedio! {
            mejorPromedio = promedio
            mejoresTiempos = subTiempos
        }
    }
    return mejoresTiempos ?? [0.0]
}



func PBmo3(lista: [Double]) -> [Double] {
    guard lista.count >= 3 else {
        return [0.0]
    }
    
    var minSum = Double.infinity
    var resultado: [Double] = []
    
    for i in 0...(lista.count - 3) {
        let sum = lista[i] + lista[i+1] + lista[i+2]
        if sum < minSum {
            minSum = sum
            resultado = [lista[i], lista[i+1], lista[i+2]]
        }
    }
    return resultado
}



func desviacion(valores: [Double]) -> String {
    let count = Double(valores.count)
    
    // Si hay menos de 2 elementos en la lista, retornar "0.00"
    guard count >= 2 else {
        return "0.00"
    }
    
    // Calcular la media
    let media = valores.reduce(0.0, +) / count
    
    // Calcular la suma de los cuadrados de las diferencias
    let sumatorioCuadradosDiferencias = valores.reduce(0.0) { result, valor in
        let diferencia = valor - media
        return result + (diferencia * diferencia)
    }
    
    // Calcular la desviación estándar
    let desviacion = sqrt(sumatorioCuadradosDiferencias / (count - 1))
    
    // Formatear la desviación como un String con dos decimales
    return String(format: "%.2f", desviacion)
}

func grafica(valores: [Double]) -> [Item] {
    var items: [Item] = []
    
    for (index, value) in valores.enumerated() {
        let item = Item(value: Double(value), fecha: "\(index + 1)")
        items.append(item)
    }
    
    return items
}
