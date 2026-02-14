import SwiftUI
import Charts

struct Item: Identifiable{
    var id = UUID()
    var value: Double
    var fecha: String
}

struct EstadisticasView: View {
    
    @ObservedObject var vm: RubikViewModel
    
    var actual: [Double] {
        obtenerTiempos(sesion: vm.sesionActual)
    }

    var indiceActual: Int {
        max(actual.count - 1, 0)
    }
    
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                ScrollView {
                    
                    TiemposBasicosView(actual: actual)
                    
                    TiemposActualesView(actual: actual)
                    
                    TiemposPBView(
                        actual: actual,
                        sesionActual: vm.sesionActual
                    )
                    
                    Chart(grafica(valores: actual)) { i in
                        LineMark(
                            x: .value("fecha", i.fecha),
                            y: .value("dato", i.value)
                        )
                    }
                    .padding(20)
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(20)
                    .foregroundColor(.purple)
                    .padding(20)
                    .padding(.top, -5)
                }
            }
            .navigationTitle("\(vm.sesionActual.nombre) 📊")
            
            .navigationBarTitleDisplayMode(.large) // .inline si lo quieres pequeño
        }
    }
}

#Preview {
    ContentView()
}
