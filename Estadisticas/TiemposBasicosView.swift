import SwiftUI

struct TiemposBasicosView: View {
    
    let actual: [Double]
    
    var body: some View {
        
        let mean = formatoTiempo(media(tiempos: actual, cantidad: actual.count))
        let peor = formatoTiempo(actual.max() ?? 0.00)
        let mejor = formatoTiempo(actual.min() ?? 0.00)
        
        HStack {
            
            bloqueSimple(
                titulo: "Cantidad",
                tiempo: "\(actual.count)")
            
            bloqueSimple(
                titulo: "Media",
                tiempo: "\(mean.dropLast())")
            
            VStack{
                
                Text("Mejor/Peor")
                    .bold()
                    .foregroundColor(.gray)
                    .font(.custom("Avenir", size: 16))
                Text("\(mejor.dropLast())")
                    .bold()
                    .foregroundColor(.blue)
                    .padding(.bottom,-16)
                    .font(.custom("Avenir", size: 23))
                Text("\(peor.dropLast())")
                    .bold()
                    .foregroundColor(.red)
                    .padding(.bottom,-6)
                    .font(.custom("Avenir", size: 23))
            }.padding(8)
                .background(Color(.gray).opacity(0.25))
                .cornerRadius(15)
            
            
        }.padding(.vertical,20)
            .padding(.bottom,-30)
    }
    
    @ViewBuilder
    func bloqueSimple(titulo: String, tiempo: String) -> some View {
        VStack{
            Text(titulo)
                .bold()
                .foregroundColor(.gray)
                .font(.custom("Avenir", size: 16))
            Text(tiempo)
                .bold()
                .padding(.bottom,-5)
                .font(.custom("Avenir", size: 35))
        }
        .padding(10)
        .background(Color(.gray).opacity(0.25))
        .cornerRadius(15)
    }
    

    
}
