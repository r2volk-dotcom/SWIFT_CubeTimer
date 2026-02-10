import SwiftUI

struct EstadisticasCronometroView: View {
    
    let sesionActual: Sesion
    
    var body: some View {
        
        HStack{
            
                VStack(alignment:.leading ){
                    let listaTiempo = obtenerTiempos(sesion: sesionActual)
                    let mean = media(tiempos: obtenerTiempos(sesion: sesionActual), cantidad: listaTiempo.count == 0 ? 1 : listaTiempo.count)
                    let peor = obtenerMejorPeor(listaTiempos: listaTiempo, tipo: "peor")
                    let mejor = obtenerMejorPeor(listaTiempos: listaTiempo, tipo: "mejor")
                    Text("Solves: \(listaTiempo.count)")
                    Text("Media: \(mean <= 60 ? "\(formatoTiempo(mean).dropLast())" : "\(formatoTiempo(mean).dropLast(2))")")
                    Text("Peor: \(peor <= 60 ? "\(formatoTiempo(peor).dropLast())" : "\(formatoTiempo(peor).dropLast(2))")")
                    Text("Mejor: \(mejor <= 60 ? "\(formatoTiempo(mejor).dropLast())" : "\(formatoTiempo(mejor).dropLast(2))")")
            }
            .bold()
            .padding(10)
            .background(Color(.cyan).opacity(0.3))
            .cornerRadius(12)
            .padding(.bottom,-13)
            
            
            VStack(alignment: .center) {
                let listaTiempo = obtenerTiempos(sesion: sesionActual)
                let ultimos5 = Array(listaTiempo.suffix(5))
                
                ForEach(0..<min(listaTiempo.count, 5), id: \.self) { index in
                    let tiempo = listaTiempo[listaTiempo.count - index - 1]
                    let fontSize: CGFloat = 20 - CGFloat(index * 2)
                    
                    Text("\(tiempo <= 60 ? "\(formatoTiempo(tiempo).dropLast())" : "\(formatoTiempo(tiempo).dropLast(2))")")
                        .font(.system(size: fontSize))
                        .foregroundColor(
                            tiempo == ultimos5.max() ? .red :
                            tiempo == ultimos5.min() ? .blue :
                            .primary
                        )
                }
            }
            .bold()
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color(.gray).opacity(0.25))
            .cornerRadius(12)
            .padding(.bottom, -10)
            
            
            VStack(alignment: .leading) {
                let mean3 = media(tiempos: obtenerTiempos(sesion: sesionActual), cantidad: 3)
                let avg5 = avg(tiempos: obtenerTiempos(sesion: sesionActual), cantidad: 5)
                let avg12 = avg(tiempos: obtenerTiempos(sesion: sesionActual), cantidad: 12)
                let avg50 = avg(tiempos: obtenerTiempos(sesion: sesionActual), cantidad: 50)
                
                Text("Mo3: \(mean3 <= 60 ? "\(formatoTiempo(mean3).dropLast())" : "\(formatoTiempo(mean3).dropLast(2))")")
                Text("Avg5: \(avg5 <= 60 ? "\(formatoTiempo(avg5).dropLast())" : "\(formatoTiempo(avg5).dropLast(2))")")
                Text("Avg12: \(avg12 <= 60 ? "\(formatoTiempo(avg12).dropLast())" : "\(formatoTiempo(avg12).dropLast(2))")")
                Text("Avg50: \(avg50 <= 60 ? "\(formatoTiempo(avg50).dropLast())" : "\(formatoTiempo(avg50).dropLast(2))")")
            }
            .bold()
            .padding(10)
            .background(Color(.red).opacity(0.3))
            .cornerRadius(12)
            .padding(.bottom, -13)

        }
    }
}

#Preview {
    ContentView()
}
