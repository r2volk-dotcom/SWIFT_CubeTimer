import SwiftUI

struct CustomTabBar: View {
    
    @Binding var selectedTab: Int
    
    var body: some View {
        
        HStack {
            ZStack {
                Rectangle()
                    .frame(width: 300,height: 57)
                    .foregroundColor(.gray.opacity(0.25))
                    .cornerRadius(25)
                    .padding(.bottom,-20)
                
                HStack{
                    
                    tabButton(
                        iconOn: "stopwatch.fill",
                        iconOff: "stopwatch",
                        index: 0,
                        paddingL: 0,
                        paddingT: -13)
                
                    tabButton(
                        iconOn: "tray.fill",
                        iconOff: "tray",
                        index: 1,
                        paddingL: 0,
                        paddingT: -8)
                    
                    tabButton(
                        iconOn: "chart.bar.fill",
                        iconOff: "chart.bar",
                        index: 2,
                        paddingL: -7,
                        paddingT: 0)
                
                    tabButton(
                        iconOn: "archivebox.fill",
                        iconOff: "archivebox",
                        index: 3,
                        paddingL: -16,
                        paddingT: 0)
                    
                }//Hstack
            }//Zstack
        }
        
    }
    
    @ViewBuilder
    func tabButton(iconOn: String, iconOff: String, index: Int, paddingL: Double, paddingT: Double) ->some View{
        Button(action: {
            self.selectedTab = index
        }) {
            Image(systemName: selectedTab == index ? iconOn : iconOff )
                .font(.system(size: 28))
                .scaleEffect(selectedTab == index ? 1.3 : 1)
                .padding()
                .padding(.bottom,-15)
                .padding(.leading,paddingL)
                .padding(.trailing,paddingT)
                .foregroundColor(selectedTab == index ? .teal : .gray)
        }
        .foregroundColor(selectedTab == index ? Color.gray.opacity(0.3) : Color.clear)
    }
    
}


#Preview {
    ContentView()
}
