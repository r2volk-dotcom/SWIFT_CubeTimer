import Foundation

class Sesion: Codable, Identifiable, Equatable {
    var id: UUID
    var tiempos: [Tiempo]
    var nombre: String
    var categoria: String
    
    init(tiempos: [Tiempo], nombre: String, categoria: String) {
        self.id = UUID()
        self.tiempos = tiempos
        self.nombre = nombre
        self.categoria = categoria
    }
    
    // Implementación de Equatable
    static func == (lhs: Sesion, rhs: Sesion) -> Bool {
        return lhs.id == rhs.id &&
               lhs.nombre == rhs.nombre &&
               lhs.categoria == rhs.categoria &&
               lhs.tiempos == rhs.tiempos
    }
}

class Tiempo: Codable, Identifiable, Equatable {
    var id: UUID
    var tiempo: Double
    var scramble: String
    var fecha: Date
    
    init(tiempo: Double, scramble: String, fecha: Date) {
        self.id = UUID()
        self.tiempo = tiempo
        self.scramble = scramble
        self.fecha = fecha
    }
    
    // Implementación de Equatable
    static func == (lhs: Tiempo, rhs: Tiempo) -> Bool {
        return lhs.id == rhs.id &&
               lhs.tiempo == rhs.tiempo &&
               lhs.scramble == rhs.scramble &&
               lhs.fecha == rhs.fecha
    }
}

enum Orden: String, CaseIterable {
    case fecha = "Fecha"
    case ascendente = "Ascendente"
    case descendente = "Descendente"
}

struct TimerState {
    var estaCorriendo: Bool
    var estaTocando: Bool
    var tiempoInicio: Date?
    var tiempoTranscurrido:TimeInterval
    var visibilidadPromedios: Bool
}
