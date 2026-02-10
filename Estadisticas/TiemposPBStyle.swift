import SwiftUI

struct TiemposPBStyle: View {
    
    let titulo: String
    let tiempo: String
    
    let listaParaMostrar: [Double]

    @Binding var mostrarTiempos: [Double]
    @Binding var arriba: Bool
    
    var body: some View {
        VStack{
            Text(titulo)
                .bold()
                .foregroundColor(.gray)
                .font(.custom("Avenir", size: 16))
            Text(tiempo)
                .bold()
                .padding(.bottom,-8)
                .font(.custom("Avenir", size: 38))
                .gesture(TapGesture().onEnded({
                    mostrarTiempos = listaParaMostrar
                    arriba = true
                }))
        }.padding(10)
            .padding(.vertical,-3)
            .background(Color(.gray).opacity(0.25))
            .cornerRadius(13)
    }
}
