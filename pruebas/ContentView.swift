import SwiftUI
import SwiftData

class Sesion: Codable, Identifiable, Equatable {
    var id: UUID
    var tiempos: [Tiempo]
    var nombre: String
    var categoria: String
    
    init(tiempos: [Tiempo], nombre: String, categoria: String) {
        self.id = UUID()
        self.tiempos = tiempos
        self.nombre = nombre
        self.categoria = categoria
    }
    
    // Implementación de Equatable
    static func == (lhs: Sesion, rhs: Sesion) -> Bool {
        return lhs.id == rhs.id &&
               lhs.nombre == rhs.nombre &&
               lhs.categoria == rhs.categoria &&
               lhs.tiempos == rhs.tiempos
    }
}

class Tiempo: Codable, Identifiable, Equatable {
    var id: UUID
    var tiempo: Double
    var scramble: String
    var fecha: Date
    
    init(tiempo: Double, scramble: String, fecha: Date) {
        self.id = UUID()
        self.tiempo = tiempo
        self.scramble = scramble
        self.fecha = fecha
    }
    
    // Implementación de Equatable
    static func == (lhs: Tiempo, rhs: Tiempo) -> Bool {
        return lhs.id == rhs.id &&
               lhs.tiempo == rhs.tiempo &&
               lhs.scramble == rhs.scramble &&
               lhs.fecha == rhs.fecha
    }
}


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
        
        VStack {
            if selectedTab == 0 {
                crnmt(sesionActual:$sesionActual,
                      tiemposPrincipal: $tiemposPrincipal,
                      scrambleActual: $scrambleActual,
                      tiemposRecorrer: $tiemposRecorrer,
                      guardarSesiones: guardarSesiones
                ).onAppear {
                    scrambleActual = scrambleMostrar(categoria: categoriaSeleccionada)
                    tiemposRecorrer = obtenerTiemposRecorrer(categoria: categoriaSeleccionada, nombreCategoria: nombreSeleccionada, listaSesiones: tiemposPrincipal).reversed()
                    sesionActual = obtenerSesionActual(categoria: categoriaSeleccionada, nombreCategoria: nombreSeleccionada, listaSesiones: tiemposPrincipal)
                    idActual = sesionActual.id
                    cargarSesiones()
                    
                }.onChange(of: tiemposPrincipal) { _ in
                    guardarSesiones()
            }
                
            } else if selectedTab == 1 {
                
                listatimes(tiemposRecorrer: $tiemposRecorrer,
                           categoriaSeleccionada:$categoriaSeleccionada,
                           nombreSeleccionada:$nombreSeleccionada,
                           idActual: $idActual,
                           tiemposPrincipal: $tiemposPrincipal,
                           guardarSesiones: guardarSesiones)
                .onAppear {
                        tiemposRecorrer = obtenerTiemposRecorrer(categoria: categoriaSeleccionada, nombreCategoria: nombreSeleccionada, listaSesiones: tiemposPrincipal).reversed()
                    cargarSesiones()
                }.onChange(of: tiemposPrincipal) { _ in
                    guardarSesiones()
            }
                
            }else if selectedTab == 2 {
                estadisticas(sesionActual: $sesionActual
                             ,valor: $valor)
                .onAppear {
                    sesionActual = obtenerSesionActual(categoria: categoriaSeleccionada, nombreCategoria: nombreSeleccionada, listaSesiones: tiemposPrincipal)
                    
                }
                
            }else if selectedTab == 3 {
                
                categorias(tiemposPrincipal: $tiemposPrincipal,
                           categoriaSeleccionada:$categoriaSeleccionada,
                           nombreSeleccionada:$nombreSeleccionada,
                           idActual: $idActual)
                .onAppear {
                    scrambleActual = scrambleMostrar(categoria: categoriaSeleccionada)
                    idActual = sesionActual.id
                    tiemposRecorrer = obtenerTiemposRecorrer(categoria: categoriaSeleccionada, nombreCategoria: nombreSeleccionada, listaSesiones: tiemposPrincipal).reversed()
                    cargarSesiones()
                }.onChange(of: tiemposPrincipal) { _ in
                    guardarSesiones()
                }
            }
            
            //TAB BAR PERSONALIZADA :)
            CustomTabBar(selectedTab: $selectedTab)
            
        }
    }
    
}

#Preview {
    ContentView()
}
