import SwiftUI

struct CrearCategoriaView: View{

    @ObservedObject var vm: RubikViewModel
    
    @State private var nuevoNombre = ""
    @State private var nuevaCategoria = "3x3"
    
    @Binding var mostrarFormulario: Bool
    @Binding var mostrarAlertaNombreInvalido: Bool
    
    var body: some View {
        
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
            categoriasHStack(categorias: ["Megaminx", "3x3 OH", "2x2", "3x3"])
            
            categoriasHStack(categorias: ["Pyraminx", "3x3 BLD", "4x4", "5x5"])
            
            categoriasHStack(categorias: ["Square 1", "Skewb", "6x6", "7x7"])
            
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
                    vm.tiemposPrincipal.append(nuevaSesion)
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
        
    }
    
    @ViewBuilder
    func categoriasHStack(categorias:[String]) -> some View{
        HStack {
            ForEach(categorias, id: \.self) { categoria in
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
    }
    
}
