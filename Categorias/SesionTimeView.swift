import SwiftUI

struct SesionTimeView: View {
    
    @ObservedObject var vm: RubikViewModel
    
    let sesion: Sesion
    let eliminarTiempo: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View{
        
        Button(action: {
            vm.idActual = sesion.id
            vm.nombreSeleccionada = sesion.nombre
            vm.categoriaSeleccionada = sesion.categoria
            vm.nuevoScramble()
        }) {
            HStack {
                Text(sesion.nombre)
                    .foregroundColor(vm.idActual == sesion.id ?
                                     (colorScheme == .dark ? .black : .white) : .primary.opacity(0.4))
                    .padding(.horizontal, vm.idActual == sesion.id ? 10 : 15 )
                    .padding(.vertical, vm.idActual == sesion.id ? 8 : 10 )
                    .bold()
                    .font(.system(size: 25))
                    .background(Color(vm.idActual == sesion.id ? .cyan : .gray.opacity(0.3)))
                    .cornerRadius(10)
                    .padding(.horizontal, vm.idActual == sesion.id ? 10 : -20)
                
                Spacer()
                
                Text(sesion.categoria)
                    .padding(.horizontal, vm.idActual != sesion.id ? -15 :
                                sesion.categoria == "Megaminx" ? -100 :
                                sesion.categoria == "Skewb" ? -75 :
                                sesion.categoria == "Pyraminx" ? -95 :
                                sesion.categoria == "Square 1" ? -88 :
                                sesion.categoria == "3x3 BLD" ? -85 :
                                sesion.categoria == "3x3 OH" ? -82 : -50)
                    .bold()
                    .foregroundColor(vm.idActual == sesion.id ? .primary : .gray.opacity(0.5))
                    .font(.system(size: 20))
            }
            .scaleEffect(vm.idActual == sesion.id ? 1.1 : 0.9)
            .animation(.easeInOut, value: vm.idActual)
            .contextMenu {
                // Mostrar la alerta de confirmación de eliminación
                Button("Eliminar") {
                    eliminarTiempo()
                }
            }
        }
    }
    
    
    
}
