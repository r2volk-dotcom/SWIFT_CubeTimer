import SwiftUI

struct TiemposActualesView: View {
    
    let actual: [Double]
    
    var body: some View {
        
        let indiceActual = actual.count-1
        
        let mean3 = formatoTiempo(media(tiempos: actual, cantidad: 3))
        let avg5 = formatoTiempo(avg(tiempos: actual, cantidad: 5))
        let avg12 = formatoTiempo(avg(tiempos: actual, cantidad: 12))
        let avg25 = formatoTiempo(avg(tiempos: actual, cantidad: 25))
        let avg50 = formatoTiempo(avg(tiempos: actual, cantidad: 50))
        let avg100 = formatoTiempo(avg(tiempos: actual, cantidad: 100))
        let avg200 = formatoTiempo(avg(tiempos: actual, cantidad: 200))
        let avg500 = formatoTiempo(avg(tiempos: actual, cantidad: 500))
        let avg1000 = formatoTiempo(avg(tiempos: actual, cantidad: 1000))
        
        let ultimoSingle = actual.count>0 ? "\(formatoTiempo(actual[indiceActual]).dropLast())" : "0.0"

        
        VStack {
            Text("Actual")
                .padding(.trailing,192)
                .bold()
                .font(.custom("Avenir", size: 38))
                .padding(.bottom,5)
        
            HStack {
                
                crearBoton(
                    titulo: "Ultimo",
                    tiempo: ultimoSingle)
                
                crearBoton(
                    titulo: "mo3",
                    tiempo: "\(mean3.dropLast())")

            }
            
            HStack{
                
                crearBoton(
                    titulo: "avg5",
                    tiempo: "\(avg5.dropLast())")
                
                crearBoton(
                    titulo: "avg12",
                    tiempo: "\(avg12.dropLast())")
        
            }
            
            HStack {
                
                crearBoton(
                    titulo: "avg25",
                    tiempo: "\(avg25.dropLast())")
                
                crearBoton(
                    titulo: "avg50",
                    tiempo: "\(avg50.dropLast())")
    
            }
            
            HStack {
                
                crearBoton(
                    titulo: "avg100",
                    tiempo: "\(avg100.dropLast())")
                
                crearBoton(
                    titulo: "avg200",
                    tiempo: "\(avg200.dropLast())")
                
            }
            
            HStack {
                
                crearBoton(
                    titulo: "avg500",
                    tiempo: "\(avg500.dropLast())")
                
                crearBoton(
                    titulo: "avg1000",
                    tiempo: "\(avg1000.dropLast())")
                
            }.padding(.bottom,15)
            
        }
        .padding(15)
        .background(Color(.green).opacity(0.3))
        .cornerRadius(20)
        .padding(20)
        .padding(.top,10)
        
    }
    
    @ViewBuilder
    private func crearBoton(titulo: String, tiempo: String) -> some View{
        VStack {
            Text(titulo) 
                .bold()
                .foregroundColor(.gray)
                .font(.custom("Avenir", size: 16))
            Text(tiempo)
                .bold()
                .padding(.bottom,-8)
                .font(.custom("Avenir", size: 38))
        }
        .padding(10)
        .padding(.vertical,-3)
        .background(Color(.gray).opacity(0.25))
        .cornerRadius(13)
    }
}

#Preview {
    ContentView()
}
