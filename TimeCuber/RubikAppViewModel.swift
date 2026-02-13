import Foundation
import SwiftUI

class RubikViewModel: ObservableObject {
    
    // CAMBIO 1: De @State a @Published
    @Published var tiemposPrincipal: [Sesion] = []
    @Published var sesionActual: Sesion = Sesion(tiempos: [], nombre: "", categoria: "")
    @Published var tiemposRecorrer: [Tiempo] = []
    @Published var scrambleActual: String = ""
    @Published var idActual: UUID? = nil //id de la session actual
    @Published var ordenActual = "Fecha"
    
    
    @Published var categoriaSeleccionada: String = UserDefaults.standard.string(forKey: "categoriaSeleccionada") ?? "3x3" {
        didSet {
            // Cuando esta variable cambie, guardamos el nuevo valor en la memoria del teléfono
            UserDefaults.standard.set(categoriaSeleccionada, forKey: "categoriaSeleccionada")
        }
    }
        
        // VARIABLE 2: El Nombre de la Sesión (Standard, etc)
    @Published var nombreSeleccionada: String = UserDefaults.standard.string(forKey: "nombreSeleccionada") ?? "Standard" {
        didSet {
            // Lo mismo: si cambia el nombre, lo guardamos
            UserDefaults.standard.set(nombreSeleccionada, forKey: "nombreSeleccionada")
        }
    }
    
    
    // CAMBIO 2: Inicializador (init)
    init() {
        cargarSesiones()
        actualizarVista()
    }

    func guardarSesiones() {
        let codificador = JSONEncoder()
        codificador.dateEncodingStrategy = .iso8601
        
        do {
            let datosCodificados = try codificador.encode(tiemposPrincipal)
            
            // CAMBIO 3: Guardamos "datosCodificados" en UserDefaults
            UserDefaults.standard.set(datosCodificados, forKey: "savedSesiones")
            
            print("Sesiones guardadas exitosamente")
        } catch {
            print("Error al guardar sesiones: \(error)")
        }
    }

    func cargarSesiones() {
        let decodificador = JSONDecoder()
        decodificador.dateDecodingStrategy = .iso8601

        if let datosGuardados = UserDefaults.standard.data(forKey: "savedSesiones"),
           let datosDecodificados = try? decodificador.decode([Sesion].self, from: datosGuardados) {
            
            tiemposPrincipal = datosDecodificados
            print("Sesiones cargadas exitosamente")
            
        } else {
            print("No hay sesiones guardadas, cargando defaults")
            tiemposPrincipal = [
                Sesion(tiempos: [], nombre: "Standard", categoria: "3x3"),
                Sesion(tiempos: [], nombre: "Standard2", categoria: "2x2"),
                Sesion(tiempos: [], nombre: "Standard4", categoria: "4x4"),
                Sesion(tiempos: [], nombre: "Standard3", categoria: "5x5"),
                Sesion(tiempos: [], nombre: "Standard6", categoria: "5x5")
            ]
        }
    }
    
    
    // ESTA ES LA FUNCIÓN QUE CALCULA TODO
    func actualizarVista() {
        // 1. Calculamos la lista de tiempos a mostrar (usando TU función global)
        tiemposRecorrer = obtenerTiemposRecorrer(
            categoria: categoriaSeleccionada,
            nombreCategoria: nombreSeleccionada,
            listaSesiones: tiemposPrincipal
        ).reversed()
        
        // 2. Buscamos la sesión actual (usando TU función global)
        sesionActual = obtenerSesionActual(
            categoria: categoriaSeleccionada,
            nombreCategoria: nombreSeleccionada,
            listaSesiones: tiemposPrincipal
        )
        
        // 3. Actualizamos el ID para que la vista sepa cuál es
        idActual = sesionActual.id
        
        // 4. Si no hay scramble (mezcla), generamos uno nuevo (usando TU función global)
        if scrambleActual.isEmpty {
            scrambleActual = scrambleMostrar(categoria: categoriaSeleccionada)
        }
    }
    
    
    func eliminarTiempoSeleccionado(tiempo:Tiempo){
        for index in tiemposPrincipal.indices {
            if tiemposPrincipal[index].id == idActual {
                tiemposPrincipal[index].tiempos.removeAll { $0.id == tiempo.id }
                tiemposRecorrer = ordentiemposMostrar(orden: ordenActual, catSele: categoriaSeleccionada, nomSele: nombreSeleccionada, tPrincipal: tiemposPrincipal)
                guardarSesiones()
                return
            }
        }
    }
    
    func eliminarTodosTiempos(){
        tiemposRecorrer = []
        for i in tiemposPrincipal{
            if i.id == idActual{
                i.tiempos = []
            }
        }
        guardarSesiones()
    }
    
    func cambiarOrden(orden: String) {
        ordenActual = orden
        tiemposRecorrer = ordentiemposMostrar(
            orden: ordenActual,
            catSele: categoriaSeleccionada,
            nomSele: nombreSeleccionada,
            tPrincipal: tiemposPrincipal
        )
    }
    
    func actualizarDatos(nuevosTiempos: [Sesion]) {
            self.tiemposPrincipal = nuevosTiempos
            self.tiemposRecorrer = obtenerTiemposRecorrer(
                categoria: categoriaSeleccionada,
                nombreCategoria: nombreSeleccionada,
                listaSesiones: self.tiemposPrincipal
            ).reversed()
        }
        
    // Una pequeña ayuda para generar nuevo scramble manualmente cuando quieras
    /*func nuevoScramble() {
        scrambleActual = scrambleMostrar(categoria: categoriaSeleccionada)
    }
     */
}

/*
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
     ListaTiemposView(
             vm: ListaTiemposViewModel(
                 tiemposPrincipal: tiemposPrincipal,     // 1. Primer argumento
                 idActual: idActual,                     // 2. Segundo argumento
                 categoriaSeleccionada: categoriaSeleccionada, // 3. Tercer argumento
                 nombreSeleccionada: nombreSeleccionada,       // 4. Cuarto argumento
                 guardarSesiones: guardarSesiones        // 5. Sin paréntesis ()
             ),
             tiemposPrincipal: $tiemposPrincipal,
             guardarSesiones: guardarSesiones,
             // 6. Argumento requerido por la View
         )
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
     CategoriasView(tiemposPrincipal: $tiemposPrincipal,
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
 */
