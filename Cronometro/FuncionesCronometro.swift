
import Foundation

func paddingCronometroCorriendo(tiempoTranscurrido: Double) -> Double {
    if tiempoTranscurrido > 59.9 {
        return 10.0
    } else if tiempoTranscurrido > 9.99 && tiempoTranscurrido <= 59.9 {
        return 50.0
    } else if tiempoTranscurrido > 0.01 && tiempoTranscurrido <= 99.9 {
        return 80.0
    } else {
        return 90.0
    }
}
