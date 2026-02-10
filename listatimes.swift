import SwiftUI

struct listatimes: View {
    
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
                    Button(action: {
                    }) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(formatoTiempo(tiempo.tiempo))")
                                    .font(.system(size: 28))
                                    .fontWeight(.heavy)
                                Spacer()
                                Text("\(formatoFecha(tiempo.fecha))")
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                                    .font(.system(size: 18))
                            }
                            .padding(.bottom, 5)
                            
                            Text("\(tiempo.scramble)")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                                .bold()
                                .contextMenu(
                                ContextMenu(menuItems: {
                                    Button("Eliminar "){
                                        for index in tiemposPrincipal.indices {
                                            if tiemposPrincipal[index].id == idActual {
                                                tiemposPrincipal[index].tiempos.removeAll { $0.id == tiempo.id }
                                                tiemposRecorrer = ordentiemposMostrar(orden: ordenActual, catSele: categoriaSeleccionada, nomSele: nombreSeleccionada, tPrincipal: tiemposPrincipal)
                                                guardarSesiones()
                                                return
                                            }
                                        }
                                    }
                                }))
                            
                        }
                    }
                }
            }.navigationTitle("Tiempos⌛️")
            .navigationBarItems(trailing: Button("",systemImage: "arrow.up.arrow.down.circle",action: {
                manejo = true
            }))
            .navigationBarItems(trailing: Button("",systemImage: "trash",action: {
                seguridad = true
            }))
                
            }.actionSheet(isPresented: $manejo, content: {
                ActionSheet(title:Text("Orden"),
                            buttons:[.default(Text("Fecha"), action: {
                    ordenActual = "Fecha"
                    tiemposRecorrer = ordentiemposMostrar(orden: ordenActual, catSele: categoriaSeleccionada, nomSele: nombreSeleccionada, tPrincipal: tiemposPrincipal)}),
                                     .default(Text("Ascendente"), action: {
                                         ordenActual = "Ascendente"
                                         tiemposRecorrer = ordentiemposMostrar(orden: ordenActual, catSele: categoriaSeleccionada, nomSele: nombreSeleccionada, tPrincipal: tiemposPrincipal)}),
                                     .default(Text("Descendente"), action: {
                                         ordenActual = "Descendente"
                                         tiemposRecorrer = ordentiemposMostrar(orden: ordenActual, catSele: categoriaSeleccionada, nomSele: nombreSeleccionada, tPrincipal: tiemposPrincipal)}),
                                     .destructive(Text("Cancelar"))])
            })
            .alert(isPresented: $seguridad, content: {
                    Alert(title:Text("Eliminar"),
                          message: Text("¿Seguro que quieres eliminar TODOS tus tiempos?"),
                          primaryButton: .default(Text("Aceptar"),action: {
                        tiemposRecorrer = []
                        for i in tiemposPrincipal{
                            if i.id == idActual{
                                i.tiempos = []
                            }
                        }
                        guardarSesiones()
                    }),
                          secondaryButton: .destructive(Text("Cancelar")))
                })
    }
}

func ordentiemposMostrar(orden: String, catSele: String, nomSele: String, tPrincipal: [Sesion]) -> [Tiempo] {
    if orden == "Fecha" {
        return obtenerTiemposRecorrer(categoria: catSele, nombreCategoria: nomSele, listaSesiones: tPrincipal).reversed()
    } else if orden == "Ascendente" {
        return ordenarLista(obtenerTiemposRecorrer(categoria: catSele, nombreCategoria: nomSele, listaSesiones: tPrincipal))
    } else {
        return ordenarLista(obtenerTiemposRecorrer(categoria: catSele, nombreCategoria: nomSele, listaSesiones: tPrincipal)).reversed()
    }
}

#Preview {
    ContentView()
}
