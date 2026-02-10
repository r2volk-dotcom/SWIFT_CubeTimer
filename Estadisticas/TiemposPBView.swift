import SwiftUI

struct TiemposPBView: View {
    
    let actual: [Double]
    let sesionActual: Sesion // Necesario para el título del sheet
    
    // 2. VARIABLES DE ESTADO (Ahora viven aquí adentro, ¡más ordenado!)
    @State private var mostrarTiempos: [Double] = []
    @State private var arriba = false
    
    var body: some View {
        
        let PBm3 = PBmo3(lista: actual)
        let PBavg5 = PBavg(tiempos: actual, x: 5)
        let PBavg12 = PBavg(tiempos: actual, x: 12)
        let PBavg25 = PBavg(tiempos: actual, x: 25)
        let PBavg50 = PBavg(tiempos: actual, x: 50)
        let PBavg100 = PBavg(tiempos: actual, x: 100)
        let PBavg200 = PBavg(tiempos: actual, x: 200)
        let PBavg500 = PBavg(tiempos: actual, x: 500)
        let PBavg1000 = PBavg(tiempos: actual, x: 1000)
        let PB3 = formatoTiempo(media(tiempos: PBm3, cantidad: 3))
        let PB5 = formatoTiempo(avg(tiempos: PBavg5, cantidad: 5))
        let PB12 = formatoTiempo(avg(tiempos: PBavg12, cantidad: 12))
        let PB25 = formatoTiempo(avg(tiempos: PBavg25, cantidad: 25))
        let PB50 = formatoTiempo(avg(tiempos: PBavg50, cantidad: 50))
        let PB100 = formatoTiempo(avg(tiempos: PBavg100, cantidad: 100))
        let PB200 = formatoTiempo(avg(tiempos: PBavg200, cantidad: 200))
        let PB500 = formatoTiempo(avg(tiempos: PBavg500, cantidad: 500))
        let PB1000 = formatoTiempo(avg(tiempos: PBavg1000, cantidad: 1000))
        let desvi = desviacion(valores: actual)
        
        VStack {
        
            
            Text("PBs")
                .padding(.trailing,192)
                .bold()
                .font(.custom("Avenir", size: 38))
                .padding(.bottom,5)
            
            
            HStack {
                TiemposPBStyle(
                        titulo: "mo3",
                        tiempo: "\(PB3.dropLast())",
                        listaParaMostrar: PBmo3(lista: actual),
                        mostrarTiempos: $mostrarTiempos,
                        arriba: $arriba
                    )
                
                crearBoton(
                    titulo: "avg5",
                    tiempo: "\(PB5.dropLast())",
                    cantidadTiempos: 5)
            }
            
            
            HStack {
                crearBoton(
                    titulo: "avg12",
                    tiempo: "\(PB12.dropLast())",
                    cantidadTiempos: 12)
                
                crearBoton(
                    titulo: "avg25",
                    tiempo: "\(PB25.dropLast())",
                    cantidadTiempos: 25)
            }
            
            
            HStack {
                crearBoton(
                    titulo: "avg50",
                    tiempo: "\(PB50.dropLast())",
                    cantidadTiempos: 50)
                
                crearBoton(
                    titulo: "avg100",
                    tiempo: "\(PB100.dropLast())",
                    cantidadTiempos: 100)
            }
            
            
            HStack {
                crearBoton(
                    titulo: "avg200",
                    tiempo: "\(PB200.dropLast())",
                    cantidadTiempos: 200)
                
                crearBoton(
                    titulo: "avg500",
                    tiempo: "\(PB500.dropLast())",
                    cantidadTiempos: 500)
            }

            
            HStack{
                crearBoton(
                    titulo: "avg1000",
                    tiempo: "\(PB1000.dropLast())",
                    cantidadTiempos: 1000)
                
                VStack{
                    Text("Desviación")
                        .bold()
                        .foregroundColor(.gray)
                        .font(.custom("Avenir", size: 16))
                    Text("\(desvi)")
                        .bold()
                        .padding(.bottom,-8)
                        .font(.custom("Avenir", size: 38))
                }.padding(10)
                    .padding(.vertical,-3)
                    .background(Color(.gray).opacity(0.25))
                    .cornerRadius(13)
                
            }.padding(.bottom,15)
            
        }.padding(15)
            .background(Color(.pink).opacity(0.25))
            .cornerRadius(20)
            .padding(20)
            .padding(.top,-15)
            .sheet(isPresented: $arriba, onDismiss: {arriba = false}, content: {
                NavigationView{
                        List {
                            Section(header: Text("\(sesionActual.nombre)")) {
                                ForEach(mostrarTiempos.indices, id: \.self) { index in
                                    let reversedIndex = mostrarTiempos.count - index - 1
                                    HStack{
                                        Text("\(index + 1).")
                                            .foregroundColor(.red)
                                        Text("\(formatoTiempo(mostrarTiempos[reversedIndex]))")
                                            .font(.system(size: 25))
                                    }
                                }.bold()
                            }
                        }.navigationTitle("TIEMPOS 🌟 ")
                    }
            })
    }
    
    @ViewBuilder
    private func crearBoton(titulo: String, tiempo: String, cantidadTiempos: Int) -> some View{
        TiemposPBStyle(
            titulo: titulo,
            tiempo: tiempo,
            listaParaMostrar: PBavg(tiempos: actual, x: cantidadTiempos),
            mostrarTiempos: $mostrarTiempos,
            arriba: $arriba)
    }
        
}

#Preview {
    ContentView()
}
