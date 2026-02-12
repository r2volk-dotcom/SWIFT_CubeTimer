import Foundation

struct TimerState {
    var estaCorriendo: Bool
    var estaTocando: Bool
    var tiempoInicio: Date?
    var tiempoTranscurrido:TimeInterval
    var visibilidadPromedios: Bool
}
