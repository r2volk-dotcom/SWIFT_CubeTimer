import SwiftUI
import Charts

struct Item: Identifiable{
    var id = UUID()
    var value: Double
    var fecha: String
}

struct estadisticas: View {
    
    @Binding var sesionActual: Sesion
    @Binding var valor:Int
    
    
    var actual: [Double] {
        obtenerTiempos(sesion: sesionActual)
    }

    var indiceActual: Int {
        max(actual.count - 1, 0)
    }
    
    
    var body: some View {
        
        //TITULO
        Text("\(sesionActual.nombre) 📊")
            .foregroundColor(.teal)
            .bold()
            .font(.custom("Avenir", size: 38))
            .padding(.vertical,-6)
        
        
        ScrollView{
    
            //Tiempos Basicos
            TiemposBasicosView(actual: actual)
            
            
            //Tiempos Actuales
            TiemposActualesView(actual: actual)
            
            
            //Tiempos PB
            TiemposPBView(
                actual: actual,
                sesionActual: sesionActual)
            
            
            //Desviacion
            Chart(grafica(valores: actual)) { i in
                LineMark(x: .value("fecha",i.fecha),
                         y: .value("dato", i.value))
            }
            .padding(20)
            .background(Color(.purple).opacity(0.2))
            .cornerRadius(20)
            .foregroundColor(.purple)
            .padding(20)
            .padding(.top,-5)
            
        }
    }
}

#Preview {
    ContentView()
}
