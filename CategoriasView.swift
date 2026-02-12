import SwiftUI

struct CategoriasView: View {
    
    @Binding var tiemposPrincipal: [Sesion]
    @Binding var categoriaSeleccionada: String
    @Binding var nombreSeleccionada: String
    
    @Binding var idActual: UUID?

    @State private var nuevoNombre = "" // Nombre de la nueva sesión
    @State private var nuevaCategoria = "3x3"
    @State private var mostrarFormulario = false
    @State private var mostrarAlertaNombreInvalido = false
    
    @State private var mostrarAlertaEliminar = false // Estado para manejar la alerta de eliminación
    @State private var sesionAEliminar: Sesion? // Sesión seleccionada para eliminar
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tiemposPrincipal, id: \.id) { sesion in
                    Button(action: {
                        self.idActual = sesion.id
                        self.nombreSeleccionada = sesion.nombre
                        self.categoriaSeleccionada = sesion.categoria
                    }) {
                        HStack {
                            Text(sesion.nombre)
                                .foregroundColor(self.idActual == sesion.id ?
                                                     (colorScheme == .dark ? .black : .white) : .primary.opacity(0.4))
                                .padding(.horizontal, idActual == sesion.id ? 10 : 15 )
                                .padding(.vertical, idActual == sesion.id ? 8 : 10 )
                                .bold()
                                .font(.system(size: 25))
                                .background(Color(self.idActual == sesion.id ? .cyan : .gray.opacity(0.3)))
                                .cornerRadius(10)
                                .padding(.horizontal, idActual == sesion.id ? 10 : -20)
                        
                            Spacer()
                            
                            Text(sesion.categoria)
                                .padding(.horizontal, idActual != sesion.id ? -15 :
                                            sesion.categoria == "Megaminx" ? -100 :
                                            sesion.categoria == "Skewb" ? -75 :
                                            sesion.categoria == "Pyraminx" ? -95 :
                                            sesion.categoria == "Square 1" ? -88 :
                                            sesion.categoria == "3x3 BLD" ? -85 :
                                            sesion.categoria == "3x3 OH" ? -82 : -50)
                                .bold()
                                .foregroundColor(self.idActual == sesion.id ? .primary : .gray.opacity(0.5))
                                .font(.system(size: 20))
                        }
                        .scaleEffect(idActual == sesion.id ? 1.1 : 0.9)
                        .animation(.easeInOut, value: idActual)
                        .contextMenu {
                            // Mostrar la alerta de confirmación de eliminación
                            Button("Eliminar") {
                                sesionAEliminar = sesion // Guardamos la sesión a eliminar
                                mostrarAlertaEliminar = true // Mostramos la alerta
                            }
                        }
                    }
                }
            }
            .navigationTitle("Categorías 🌟")
            .navigationBarItems(trailing: Button(action: {
                self.mostrarFormulario = true
                print(mostrarFormulario)// Mostrar el formulario para agregar sesión
            }) {
                Image(systemName: "plus")
                    .font(.title3)
                    .foregroundColor(.blue)
            })
            .sheet(isPresented: $mostrarFormulario) {
                VStack {
                    Text("Nueva Sesión 🔥")
                        .bold()
                        .font(.title)
                        .padding()
                    
                    TextField("Nombre de la sesión", text: $nuevoNombre)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .bold()
                        .padding()
                    
                    // Botones para seleccionar la categoría
                    HStack {
                        ForEach(["Megaminx", "3x3 OH", "2x2", "3x3"], id: \.self) { categoria in
                            Button(action: {
                                self.nuevaCategoria = categoria // Establecer la categoría seleccionada
                            }) {
                                Text(categoria)
                                    .font(.headline)
                                    .padding()
                                    .background(nuevaCategoria == categoria ? Color.red : Color.gray.opacity(0.2))
                                    .foregroundColor(nuevaCategoria == categoria ? .white : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.bottom)

                    HStack {
                        ForEach(["Pyraminx", "3x3 BLD", "4x4", "5x5"], id: \.self) { categoria in
                            Button(action: {
                                self.nuevaCategoria = categoria // Establecer la categoría seleccionada
                            }) {
                                Text(categoria)
                                    .font(.headline)
                                    .padding()
                                    .background(nuevaCategoria == categoria ? Color.red : Color.gray.opacity(0.2))
                                    .foregroundColor(nuevaCategoria == categoria ? .white : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.bottom)

                    HStack {
                        ForEach(["Square 1", "Skewb", "6x6", "7x7"], id: \.self) { categoria in
                            Button(action: {
                                self.nuevaCategoria = categoria // Establecer la categoría seleccionada
                            }) {
                                Text(categoria)
                                    .font(.headline)
                                    .padding()
                                    .background(nuevaCategoria == categoria ? Color.red : Color.gray.opacity(0.2))
                                    .foregroundColor(nuevaCategoria == categoria ? .white : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    Button("Agregar") {
                        // Validación del nombre de la sesión
                        if nuevoNombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            mostrarAlertaNombreInvalido = true
                        } else if nuevoNombre.count > 11 {
                            // Si el nombre excede los 12 caracteres
                            mostrarAlertaNombreInvalido = true
                        } else {
                            // Si la validación pasa, agregar la nueva sesión
                            let nuevaSesion = Sesion(tiempos: [], nombre: nuevoNombre, categoria: nuevaCategoria)
                            tiemposPrincipal.append(nuevaSesion)
                            mostrarFormulario = false // Cerrar el formulario
                            nuevoNombre = "" // Limpiar el nombre
                            nuevaCategoria = "2x2" // Restablecer la categoría
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.top)// Alerta para nombre inválido
                    .alert(isPresented: $mostrarAlertaNombreInvalido) {
                        Alert(
                            title: Text("Nombre inválido"),
                            message: Text("El nombre debe ser no vacío y de 10 caracteres o menos."),
                            dismissButton: .default(Text("Aceptar"))
                        )
                    }
                    
                    Button("Cancelar") {
                        self.mostrarFormulario = false // Cerrar el formulario
                    }
                    .padding(.top)
                }
                .padding()
            }
            
            .alert(isPresented: $mostrarAlertaEliminar) {
                if self.tiemposPrincipal.count == 1 {
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
                            if let sesionAEliminar = sesionAEliminar,
                               let index = self.tiemposPrincipal.firstIndex(where: { $0.id == sesionAEliminar.id }) {
                                self.tiemposPrincipal.remove(at: index)
                                // Si la sesión eliminada estaba seleccionada, desmarcarla
                                if self.idActual == sesionAEliminar.id {
                                    if let firstSesion = self.tiemposPrincipal.first {
                                        self.idActual = firstSesion.id
                                        self.nombreSeleccionada = firstSesion.nombre
                                        self.categoriaSeleccionada = firstSesion.categoria
                                    } else {
                                        self.idActual = nil
                                    }
                                }
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
