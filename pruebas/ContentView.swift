import SwiftUI
import SwiftData

struct ContentView: View {
    
    
    @AppStorage("savedSesiones") private var sesionesData: Data = Data()
        
    @State var tiemposPrincipal: [Sesion] = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        if let savedData = UserDefaults.standard.data(forKey: "savedSesiones"),
           let decoded = try? decoder.decode([Sesion].self, from: savedData) {
            return decoded
        } else {
            return [
                Sesion(tiempos: [], nombre: "Standard", categoria: "3x3"),
                Sesion(tiempos: [], nombre: "Standard2", categoria: "2x2"),
                Sesion(tiempos: [], nombre: "Standard4", categoria: "4x4"),
                Sesion(tiempos: [], nombre: "Standard3", categoria: "5x5"),
                Sesion(tiempos: [], nombre: "Standard6", categoria: "5x5")
            ]
        }
    }()
    

    func guardarSesiones() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let encoded = try encoder.encode(tiemposPrincipal)
            sesionesData = encoded
            print("Sesiones guardadas exitosamente")
        } catch {
            print("Error al guardar sesiones: \(error)")
        }
    }

    func cargarSesiones() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            if !sesionesData.isEmpty {
                let decoded = try decoder.decode([Sesion].self, from: sesionesData)
                tiemposPrincipal = decoded
                print("Sesiones cargadas exitosamente")
            } else {
                print("No hay sesiones guardadas")
            }
        } catch {
            print("Error al cargar sesiones: \(error)")
        }
    }
     
    @State var idActual: UUID? = nil
    @State var tiemposRecorrer: [Tiempo] = []
    
    @State var valor = 0
    
    @State private var selectedTab: Int = 0
    
    @State var sesionActual:Sesion = Sesion(tiempos: [], nombre: "", categoria: "")
    @AppStorage("categoriaSeleccionada") var categoriaSeleccionada = "3x3"
    @AppStorage("nombreSeleccionada") var nombreSeleccionada = "Standard"

    
    @State var scrambleActual: String = ""
    
    var body: some View {
   
        TabView{
            vistaCronometro()
            .tabItem {Image(systemName: "stopwatch.fill")}
            
            vistaListaTiempos()
            .tabItem {Image(systemName: "tray")}
            
            vistaEstadisticas()
            .tabItem {Image(systemName: "chart.bar")}
            
            vistaCategorias()
                .tabItem {Image(systemName: "archivebox")}
        }
        .tint(.cyan)
 
    }
    
    
    func vistaCronometro() -> some View {
        CronometroView(sesionActual:$sesionActual,
              tiemposPrincipal: $tiemposPrincipal,
              scrambleActual: $scrambleActual,
              tiemposRecorrer: $tiemposRecorrer,
              guardarSesiones: guardarSesiones
        ).onAppear {
            scrambleActual = scrambleMostrar(categoria: categoriaSeleccionada)
            tiemposRecorrer = obtenerTiemposRecorrer(categoria: categoriaSeleccionada, nombreCategoria: nombreSeleccionada, listaSesiones: tiemposPrincipal).reversed()
            sesionActual = obtenerSesionActual(categoria: categoriaSeleccionada, nombreCategoria: nombreSeleccionada, listaSesiones: tiemposPrincipal)
            idActual = sesionActual.id
            cargarSesiones()}
    }

    func vistaListaTiempos() -> some View {
        listatimes(tiemposRecorrer: $tiemposRecorrer,
                   categoriaSeleccionada:$categoriaSeleccionada,
                   nombreSeleccionada:$nombreSeleccionada,
                   idActual: $idActual,
                   tiemposPrincipal: $tiemposPrincipal,
                   guardarSesiones: guardarSesiones)
        .onAppear {
                tiemposRecorrer = obtenerTiemposRecorrer(categoria: categoriaSeleccionada, nombreCategoria: nombreSeleccionada, listaSesiones: tiemposPrincipal).reversed()
            cargarSesiones()
        }
    }
    
    func vistaEstadisticas() -> some View {
        estadisticas(sesionActual: $sesionActual
                     ,valor: $valor)
        .onAppear {
            sesionActual = obtenerSesionActual(categoria: categoriaSeleccionada, nombreCategoria: nombreSeleccionada, listaSesiones: tiemposPrincipal)
            
        }
    }
    
    func vistaCategorias() -> some View {
        categorias(tiemposPrincipal: $tiemposPrincipal,
                   categoriaSeleccionada:$categoriaSeleccionada,
                   nombreSeleccionada:$nombreSeleccionada,
                   idActual: $idActual)
        .onAppear {
            scrambleActual = scrambleMostrar(categoria: categoriaSeleccionada)
            idActual = sesionActual.id
            tiemposRecorrer = obtenerTiemposRecorrer(categoria: categoriaSeleccionada, nombreCategoria: nombreSeleccionada, listaSesiones: tiemposPrincipal).reversed()
            cargarSesiones()
        }
    }
    
}

#Preview {
    ContentView()
}
