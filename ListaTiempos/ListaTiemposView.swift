import SwiftUI

struct ListaTiemposView: View {
    
    @Binding var tiemposRecorrer: [Tiempo]
    @Binding var categoriaSeleccionada: String
    @Binding var nombreSeleccionada: String
    @Binding var idActual: UUID?
    @Binding var tiemposPrincipal: [Sesion]
    
    var guardarSesiones: () -> Void
    @State var manejo = false
    @State var idActualTiempo: UUID?
    @State var seguridad = false
    @State var ordenActual = "Fecha"

    var body: some View {
        NavigationView {
            List {
                ForEach(tiemposRecorrer, id: \.id) { tiempo in
                    TiempoRowView(
                        tiempo: tiempo,
                        onEliminar: {eliminarTiempoSeleccionado(tiempo:tiempo)})
                }
            }.navigationTitle("Tiempos⌛️")
            .navigationBarItems(trailing: Button("",systemImage: "arrow.up.arrow.down.circle",action: {
                manejo = true
            }))
            .navigationBarItems(trailing: Button("",systemImage: "trash",action: {
                seguridad = true
            }))
                
            }.actionSheet(isPresented: $manejo, content: {
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
                        eliminarTodosTiempos()
                        
                    }),
                          secondaryButton: .destructive(Text("Cancelar")))
                })
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
    
    
    func botonOrdenamiento(textoBoton:String) -> ActionSheet.Button{
        return .default(Text(textoBoton)) {
            ordenActual = textoBoton
            tiemposRecorrer = ordentiemposMostrar(
                orden: ordenActual,
                catSele: categoriaSeleccionada,
                nomSele: nombreSeleccionada,
                tPrincipal: tiemposPrincipal
            )
        }
        
        
    }

}


#Preview {
    ContentView()
}
