import SwiftUI
import UIKit

struct CronometroView: View {
    
    @Binding var sesionActual: Sesion
    @Binding var tiemposPrincipal: [Sesion]
    @Binding var scrambleActual: String
    @Binding var tiemposRecorrer: [Tiempo]
    
    var guardarSesiones: () -> Void
    
    @State var timerState = TimerState(
        estaCorriendo: false,
        estaTocando: false,
        tiempoInicio:nil,
        tiempoTranscurrido: 0,
        visibilidadPromedios: false,
    )
    
        
    var body: some View {

        VStack(spacing: 10) {
            
            //TITULO DEL CRONOMETRO
            if !timerState.estaCorriendo{
                HStack{
                    
                    Image(systemName: "trash.fill")
                        .padding(8)
                        .background(Color(.red).opacity(0.4))
                        .cornerRadius(10)
                        .font(.system(size: 23))
                        .padding(.leading,-20)
                        .onTapGesture {
                            borrarUltimoTiempo()
                        }
                    
                    Text(" \(sesionActual.nombre) 🍀")
                        .multilineTextAlignment(.center)
                        .bold()
                        .foregroundColor(.primary)
                        .font(.custom("Avenir", size: 34))
                    
                    
                }
                .padding(.horizontal)
                
            }
            
            
            //SCRAMBLE
            if !timerState.estaCorriendo {
                Text(scrambleActual)
                    .font(.system(size: sesionActual.categoria == "4x4" ? 20 :
                                    sesionActual.categoria == "5x5" ? 18 :
                                    sesionActual.categoria == "6x6" ? 13 :
                                    sesionActual.categoria == "7x7" ? 12 :
                                    sesionActual.categoria == "Megaminx" ? 11 :
                                    sesionActual.categoria == "Square 1" ? 20 : 24))
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top,15)
            }
            
            //CRONOMETRO
            TimerAreaView(
                stateTimer: $timerState,
                registrarNuevoTiempo: registrarNuevoTiempo,
                formatoTiempo: formatoTiempo)
            
            //ESTADISTICAS (EN LA PARTE INFERIOR)
            if !timerState.estaCorriendo{
                EstadisticasCronometroView(sesionActual:sesionActual)
            }
        }
        
        .padding(.top,15)
        .padding(.bottom,5)
        .toolbar(timerState.estaCorriendo ? .hidden : .visible, for: .tabBar)


    }

    
    func registrarNuevoTiempo() {
        
        if let inicio = timerState.tiempoInicio {
            timerState.tiempoTranscurrido = Date().timeIntervalSince(inicio)
            }
            
        timerState.tiempoInicio = nil
        
        guard timerState.tiempoTranscurrido >= 0.01 else { return }
        
        if let index = tiemposPrincipal.firstIndex(where: { $0.id == sesionActual.id }) {
            tiemposPrincipal[index].tiempos.append(
                Tiempo(tiempo: timerState.tiempoTranscurrido, scramble: scrambleActual, fecha: Date())
            )
            tiemposRecorrer = obtenerTiemposRecorrer(
                categoria: sesionActual.categoria,
                nombreCategoria: sesionActual.nombre,
                listaSesiones: tiemposPrincipal
            ).reversed()
            sesionActual = tiemposPrincipal[index]
            guardarSesiones()
        }
        scrambleActual = scrambleMostrar(categoria: sesionActual.categoria)
    }
    
    func borrarUltimoTiempo() {
        
        if(obtenerTiempos(sesion: sesionActual).count != 0){
            timerState.estaCorriendo = false
            timerState.tiempoTranscurrido = 0
            
            for i in tiemposPrincipal {
                if i.id == sesionActual.id {
                    if let index = tiemposPrincipal.firstIndex(where: { $0.id == sesionActual.id }) {
                        tiemposPrincipal[index].tiempos.removeLast()
                        
                        // Forzar actualización de tiemposRecorrer
                        tiemposRecorrer = obtenerTiemposRecorrer(
                            categoria: sesionActual.categoria,
                            nombreCategoria: sesionActual.nombre,
                            listaSesiones: tiemposPrincipal
                        ).reversed()
                        
                        sesionActual = tiemposPrincipal[index]
                        
                        guardarSesiones()
                    }
                    break
                }
            }
            
            scrambleActual = scrambleMostrar(categoria: sesionActual.categoria)
            self.timerState.visibilidadPromedios = true

        
        }
    }
    

}

#Preview {
    ContentView()
}
