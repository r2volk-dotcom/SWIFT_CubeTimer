import SwiftUI

struct CategoriasView: View {
    
    @ObservedObject var vm: RubikViewModel
    
    @State private var mostrarFormulario = false
    @State private var mostrarAlertaNombreInvalido = false
    
    @State private var mostrarAlertaEliminar = false // Estado para manejar la alerta de eliminación
    @State private var sesionAEliminar: Sesion? // Sesión seleccionada para eliminar
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.tiemposPrincipal, id: \.id) { sesion in
                    SesionTimeView(
                        vm:vm,
                        sesion: sesion,
                        eliminarTiempo: {
                            sesionAEliminar = sesion // Guardamos la sesión a eliminar
                            mostrarAlertaEliminar = true // Mostramos la alerta
                        })
                }
            }
            .navigationTitle("Categorías 🌟")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        mostrarFormulario = true
                    } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $mostrarFormulario) {
                CrearCategoriaView(
                    vm: vm,
                    mostrarFormulario:$mostrarFormulario,
                    mostrarAlertaNombreInvalido: $mostrarAlertaNombreInvalido)
            }
            .alert(isPresented: $mostrarAlertaEliminar) {
                if vm.tiemposPrincipal.count == 1 {
                    // Alerta para cuando solo queda una sesión
                    return Alert(
                        title: Text("No se puede eliminar"),
                        message: Text("Debe quedar al menos una sesión en la lista."),
                        dismissButton: .default(Text("Aceptar"))
                    )
                } else {
                    // Alerta de confirmación de eliminación si hay más de una sesión
                    return Alert(
                        title: Text("Confirmación"),
                        message: Text("¿Seguro que deseas eliminar esta categoría?"),
                        primaryButton: .destructive(Text("Eliminar")) {
                            // Eliminar la sesión
                            if let sesion = sesionAEliminar {
                                vm.borrarCategoria(sesionAEliminar: sesion)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            
        }
    }
}


#Preview {
    ContentView()
}
