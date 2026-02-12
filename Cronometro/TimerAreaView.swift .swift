import SwiftUI

struct TimerAreaView: View {
    
    @Binding var stateTimer:TimerState
    
    let registrarNuevoTiempo: () -> Void
    let formatoTiempo: (TimeInterval) -> String
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .fill(Color.red)
                .contentShape(Rectangle())
                .frame(maxHeight: .infinity)
                .gesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .sequenced(before: DragGesture(minimumDistance: 0))
                        .onChanged { value in
                            switch value {
                            case .first(true):
                                // Dedo presionado suficiente tiempo -> cambia color a amarillo
                                if !stateTimer.estaCorriendo {
                                    stateTimer.estaTocando = true
                                }
                            default:
                                break
                            }
                        }
                        .onEnded { value in
                            // Inicia cronómetro cuando se suelta el dedo después del long press
                            if case .second(true, _) = value, !stateTimer.estaCorriendo {
                                stateTimer.estaCorriendo = true
                                stateTimer.tiempoInicio = Date()
                                stateTimer.tiempoTranscurrido = 0
                                stateTimer.visibilidadPromedios = false
                            }
                            stateTimer.estaTocando = false
                        }
                )
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            if stateTimer.estaCorriendo {
                                stateTimer.estaCorriendo = false
                                registrarNuevoTiempo()
                                stateTimer.visibilidadPromedios = true
                            }
                        }
                )
                .onAppear {
                    // Evitar que la pantalla se apague mientras la aplicación está en primer plano
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                .onDisappear {
                    // Reactivar el apagado automático de la pantalla
                    UIApplication.shared.isIdleTimerDisabled = false
                }
            
            VStack {
                
                TimelineView(.animation) { context in
                    
                    let tiempoParaMostrar = stateTimer.estaCorriendo ? Date().timeIntervalSince(stateTimer.tiempoInicio ?? Date()) : stateTimer.tiempoTranscurrido
                    
                    Text("\(formatoTiempo(tiempoParaMostrar).dropLast())")
                        .font(.system(size: stateTimer.estaCorriendo ? 80.0 : 70.0, design: .monospaced))
                        .foregroundColor(stateTimer.estaTocando ? .yellow : .primary)
                        .fontWeight(.bold)
                    
                }
            }
            
        }
        
        
        
        
    }
}

#Preview {
    ContentView()
}
