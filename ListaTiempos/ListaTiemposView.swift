import SwiftUI

struct ListaTiemposView: View {
    
    @ObservedObject var vm: RubikViewModel
    
    //@Binding var tiemposPrincipal: [Sesion]
    
    //var guardarSesiones: () -> Void
    @State var manejo = false
    //@State var idActualTiempo: UUID?
    @State var seguridad = false
    //@State var ordenActual = "Fecha"

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
        .onAppear {
            // Esto asegura que al entrar esté actualizado
            vm.actualizarDatos(nuevosTiempos: vm.tiemposPrincipal)
        }
        .onChange(of: vm.tiemposPrincipal) { nuevosDatos in
            vm.actualizarDatos(nuevosTiempos: nuevosDatos)
        }
        .actionSheet(isPresented: $manejo, content: {
                ActionSheet(title:Text("Orden"),buttons: [
                    botonOrdenamiento(textoBoton: "Fecha"),
                    botonOrdenamiento(textoBoton: "Ascendente"),
                    botonOrdenamiento(textoBoton: "Descendente"),
                    botonOrdenamiento(textoBoton: "Cancelar")
                ])
            })
            .alert(isPresented: $seguridad, content: {
                    Alert(title:Text("Eliminar"),
                          message: Text("¿Seguro que quieres eliminar TODOS tus tiempos?"),
                          primaryButton: .default(Text("Aceptar"),action: {
                        vm.eliminarTodosTiempos()
                        
                    }),
                          secondaryButton: .destructive(Text("Cancelar")))
                })
    }
    
    func botonOrdenamiento(textoBoton:String) -> ActionSheet.Button{
        return .default(Text(textoBoton)) {
            vm.ordenActual = textoBoton
            vm.tiemposRecorrer = ordentiemposMostrar(
                orden: vm.ordenActual,
                catSele: vm.categoriaSeleccionada,
                nomSele: vm.nombreSeleccionada,
                tPrincipal: vm.tiemposPrincipal
            )
        }
        
        
    }
    

}


#Preview {
    ContentView()
}
