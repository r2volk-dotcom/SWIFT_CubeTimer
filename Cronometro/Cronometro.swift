import SwiftUI
import UIKit

struct crnmt: View {
    
    @Binding var sesionActual: Sesion
    @Binding var tiemposPrincipal: [Sesion]
    @Binding var scrambleActual: String
    @Binding var tiemposRecorrer: [Tiempo]
    
    var guardarSesiones: () -> Void
    
    @State var estaCorriendo = false
    @State var visibilidadPromedios = true
    @State var tiempoTranscurrido = 0.00
    @State var temporizador = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    @State var colorTiempo = Color.primary
    @State private var estaTocando = false
    
        
    var body: some View {
        
        Spacer()
        
        HStack{
            
            Image(systemName: "trash.fill")
                .padding(8)
                .background(Color(.red).opacity(0.4))
                .cornerRadius(10)
                .padding(.top,-160)
                .font(.system(size: 23))
                .padding(.leading,-20)
                .onTapGesture {
                    
                    if(obtenerTiempos(sesion: sesionActual).count != 0){
                        
                        estaCorriendo = false
                        tiempoTranscurrido = 0
                        
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
                        
                        self.visibilidadPromedios = true
                    
                    }
                }
            
            Text(" \(sesionActual.nombre) 🍀")
                .padding(.top,-160)
                .multilineTextAlignment(.center)
                .bold()
                .foregroundColor(.primary)
                .font(.custom("Avenir", size: 34))
            
                
        }
        
        Text("\(scrambleActual)")
            .font(.system(size: sesionActual.categoria == "4x4" ? 20 :
                            sesionActual.categoria == "5x5" ? 18 :
                            sesionActual.categoria == "6x6" ? 13 :
                            sesionActual.categoria == "7x7" ? 12 :
                            sesionActual.categoria == "Megaminx" ? 11 :
                            sesionActual.categoria == "Square 1" ? 20 : 24))

            .padding(.horizontal,20)
            .padding(.top,-120)
            .bold()
            .multilineTextAlignment(.center)
            .kerning(-0.3)
            
        VStack {
            
            Text("\(formatoTiempo(tiempoTranscurrido).dropLast())")
                .font(.system(size: estaCorriendo ? 80.0 : 70.0, design: .monospaced))
                .foregroundColor(estaTocando ? .yellow : colorTiempo)
                .fontWeight(.bold)
                .padding(.bottom,estaCorriendo ? 450:220)
                .padding(.top,estaCorriendo ? 450:125)
                .padding(.horizontal, {
                    if tiempoTranscurrido > 59.9 {
                        return 10.0
                    } else if tiempoTranscurrido > 9.99 && tiempoTranscurrido <= 59.9 {
                        return 50.0
                    } else if tiempoTranscurrido > 0.01 && tiempoTranscurrido <= 99.9 {
                        return 80.0
                    } else {
                        return 90.0
                    }
                }())
                .background(Color.gray)
                .padding(.top,25)
                .gesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .sequenced(before: DragGesture(minimumDistance: 0))
                        .onChanged { value in
                            switch value {
                            case .first(true):
                                // Dedo presionado suficiente tiempo -> cambia color a amarillo
                                if !estaCorriendo {
                                    estaTocando = true
                                }
                            default:
                                break
                            }
                        }
                        .onEnded { value in
                            // Inicia cronómetro cuando se suelta el dedo después del long press
                            if case .second(true, _) = value, !estaCorriendo {
                                estaCorriendo = true
                                tiempoTranscurrido = 0
                                visibilidadPromedios = false
                            }
                            estaTocando = false
                        }
                )
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            if estaCorriendo {
                                estaCorriendo = false
                                if tiempoTranscurrido >= 0.01 {
                                    if let index = tiemposPrincipal.firstIndex(where: { $0.id == sesionActual.id }) {
                                        tiemposPrincipal[index].tiempos.append(
                                            Tiempo(tiempo: tiempoTranscurrido, scramble: scrambleActual, fecha: Date())
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
                                visibilidadPromedios = true
                            }
                        }
                )
                .padding(.top,-70)
            
            
            if visibilidadPromedios{

                EstadisticasCronometroView(sesionActual:sesionActual)

            }
             
            
        }
        .onReceive(temporizador) { _ in
            if estaCorriendo {
                tiempoTranscurrido += 0.001
            }
        }
        .onAppear {
            // Evitar que la pantalla se apague mientras la aplicación está en primer plano
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            // Reactivar el apagado automático de la pantalla
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    }


#Preview {
    ContentView()
}
