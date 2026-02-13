import SwiftUI
import SwiftData

struct ContentView: View {
    
    @StateObject var vm = RubikViewModel()
    
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
        CronometroView(vm: vm)
            .onAppear {
                vm.scrambleActual = scrambleMostrar(categoria: vm.categoriaSeleccionada)
                vm.tiemposRecorrer = obtenerTiemposRecorrer(categoria: vm.categoriaSeleccionada, nombreCategoria: vm.nombreSeleccionada, listaSesiones: vm.tiemposPrincipal).reversed()
                vm.sesionActual = obtenerSesionActual(categoria: vm.categoriaSeleccionada, nombreCategoria: vm.nombreSeleccionada, listaSesiones: vm.tiemposPrincipal)
                vm.idActual = vm.sesionActual.id
                vm.cargarSesiones()
            }
    }

    func vistaListaTiempos() -> some View {
        ListaTiemposView(vm: vm)
        .onAppear {
            vm.tiemposRecorrer = obtenerTiemposRecorrer(
                categoria: vm.categoriaSeleccionada,
                nombreCategoria: vm.nombreSeleccionada,
                listaSesiones: vm.tiemposPrincipal).reversed()
            vm.cargarSesiones()
            vm.actualizarVista()//esto usualmente no va
        }
    }
    
    func vistaEstadisticas() -> some View {
        estadisticas(sesionActual: $vm.sesionActual)
        .onAppear {
            vm.sesionActual = obtenerSesionActual(categoria: vm.categoriaSeleccionada, nombreCategoria: vm.nombreSeleccionada, listaSesiones: vm.tiemposPrincipal)
            
        }
    }
    
    func vistaCategorias() -> some View {
        CategoriasView(tiemposPrincipal: $vm.tiemposPrincipal,
                       categoriaSeleccionada:$vm.categoriaSeleccionada,
                       nombreSeleccionada:$vm.nombreSeleccionada,
                       idActual: $vm.idActual)
        .onAppear {
            vm.scrambleActual = scrambleMostrar(
                categoria: vm.categoriaSeleccionada)
            vm.idActual = vm.sesionActual.id
            vm.tiemposRecorrer = obtenerTiemposRecorrer(
                categoria: vm.categoriaSeleccionada,
                nombreCategoria: vm.nombreSeleccionada,
                listaSesiones: vm.tiemposPrincipal).reversed()
            vm.cargarSesiones()
        }
    }
    
}

#Preview {
    ContentView()
}
