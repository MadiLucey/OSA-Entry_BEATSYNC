import SwiftUI // Imports the SwiftUI framework for building user interfaces.

struct InfoView: View { // Main view for the information page
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color(red: 1.0, green: 0.62, blue: 0.72) // pink colour
                .ignoresSafeArea() // makes the whole background pink

            VStack(spacing: 20) {
                Text("About to BeatSync") // title
                    .font(.largeTitle) // font
                    .foregroundColor(.white) // text colour
                    .bold()
                    .padding()

                Text("Each year, approximately 32,000 Australians suffer a cardiac arrest. Alarmingly, 80% of these events occur outside of hospital environments, and only about 10% of those affected survive. In many cases, there are no warning signs, cardiac arrest can strike without notice. Early detection of heart irregularities is crucial and could save thousands of lives. As wearable technology becomes more accurate and accessible, it presents an opportunity to offer a life-saving tool at a fraction of the cost of premium products like the Apple Watch or Fitbit.") // information paragraph 1
                    .multilineTextAlignment(.center) // aligns text to the centre
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.1))) // box to put the text in
                
                Text("This project aims to design and build an affordable medical bracelet that connects to a mobile application. The bracelet will measure heart rate in real time, detect abnormalities, and provide immediate feedback to the user. By identifying unusual heart activity early, the device can prompt users to seek medical attention before the situation becomes critical. This proactive approach to heart health could significantly reduce emergency cases and improve survival rates.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.1)))

                Spacer()
            }
            .padding()
            .navigationTitle("Info") // page title
            .navigationBarBackButtonHidden(true)  // Hide default back button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Home") // new home button
                        }
                    }
                }
            }
        }
    }
}

