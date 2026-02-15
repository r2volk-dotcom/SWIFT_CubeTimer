import SwiftUI

struct ListaTiemposView: View {
    
    @ObservedObject var vm: RubikViewModel
  
    @State var manejo = false
    @State var seguridad = false

    var body: some View {
        NavigationView {
            List {
                ForEach(vm.tiemposRecorrer, id: \.id) { tiempo in
                    TiempoRowView(
                        tiempo: tiempo,
                        onEliminar: {vm.eliminarTiempoSeleccionado(tiempo:tiempo)})
                }
            }.navigationTitle("Tiempos⌛️")
            .navigationBarItems(trailing: Button("",systemImage: "arrow.up.arrow.down.circle",action: {
                manejo = true
            }))
            .navigationBarItems(trailing: Button("",systemImage: "trash",action: {
                seguridad = true
            }))
                
            }
        .confirmationDialog("Orden",
                            isPresented: $manejo,
                            titleVisibility: .visible) {
            
            botonOrdenamiento(orden: .fecha)
            botonOrdenamiento(orden: .ascendente)
            botonOrdenamiento(orden: .descendente)
            
            Button("Cancelar", role: .cancel) { }
        }
            .alert(isPresented: $seguridad, content: {
                    Alert(title:Text("Eliminar"),
                          message: Text("¿Seguro que quieres eliminar TODOS tus tiempos?"),
                          primaryButton: .default(Text("Aceptar"),action: {
                        vm.eliminarTodosTiempos()
                        
                    }),
                          secondaryButton: .destructive(Text("Cancelar")))
                })
    }
    func botonOrdenamiento(orden: Orden) -> some View {
        Button(orden.rawValue) { // el texto visible
            vm.cambiarOrden(orden) // actualiza según enum
        }
    }
    

}


#Preview {
    ContentView()
}
