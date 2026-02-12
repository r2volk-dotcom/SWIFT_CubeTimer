import SwiftUI

struct TiempoRowView: View {
    
    let tiempo: Tiempo
    var onEliminar: () -> Void

    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("\(formatoTiempo(tiempo.tiempo))")
                    .font(.system(size: 28))
                    .fontWeight(.heavy)
                Spacer()
                Text("\(formatoFecha(tiempo.fecha))")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 18))
            }
            .padding(.bottom, 5)
            
            Text("\(tiempo.scramble)")
                .foregroundColor(.gray)
                .font(.system(size: 16))
                .bold()
                .contextMenu {
                    Button("Eliminar") {
                        onEliminar()
                    }
                }
            
        }
    }

}
