import SwiftUI // Imports SwiftUI for building UI components
import UserNotifications // Imports framework for handling notification permissions

// Main view for displaying a heart rate monitoring dashboard
struct DashboardView: View {
    // Observed object that manages WebSocket connection and BPM data updates
    @StateObject private var socketManager = WebSocketManager()

    var body: some View {
        ZStack {
            // Sets a pink background color that covers the entire screen
            Color(red: 1.0, green: 0.62, blue: 0.72)
                .ignoresSafeArea() // Ensures background goes under system UI elements

            VStack(spacing: 30) { // Vertical layout with spacing between components
                Spacer() // Pushes the content downward for layout balance

                // Welcome header section
                VStack(spacing: 10) {
                    Text("Welcome, admin!") // Greeting text
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white) // White text for visibility

                    Text("You're now logged in") // Subtext under greeting
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8)) // Slightly transparent
                }
                .padding() // Adds padding inside the greeting box
                .frame(maxWidth: .infinity) // Stretches full width
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.1))) // Semi-transparent background with rounded corners
                .padding(.horizontal) // Padding on the sides

                // BPM and health suggestion section
                VStack(spacing: 15) {
                    // Displays the current BPM value from WebSocket
                    Text("Current BPM: \(socketManager.bpm)")
                        .font(.title)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.5))) // Light background behind BPM
                        .padding(.horizontal)

                    // Horizontal visual separator
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .frame(height: 5)

                    Text("Normal BPM: 60–100") // Reference range
                        .font(.title3)
                        .foregroundColor(.white)

                    // Optional health advice based on BPM value
                    if let bpmInt = Int(socketManager.bpm) {
                        if bpmInt < 40 {
                            // If BPM is below 40
                            Text("Low Heart Rate")
                            Text("Suggestion: Sit or lay down and drink water")
                            Text("If still feeling dizzy consult a medical professional.")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.red)
                        } else if bpmInt > 110 {
                            // If BPM is above 110
                            Text("High Heart Rate")
                            Text("Suggestion: Sit or lay down")
                            Text("If still experiencing chest pain or shortness of breath consult a medical professional")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.red)
                        } else {
                            // If BPM is in a normal range
                            Text("BPM should be on the lower side while resting.")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                            Text("And higher while exercising")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }

                    // Notification prompt text
                    Text("Turn on notifications")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    // Navigation to an additional info view
                    NavigationLink(destination: InfoView()) {
                        Text("Information (click here)")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 2.0, green: 0.62, blue: 0.72)) // Brighter pink
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding() // Padding around the entire BPM box
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.1))) // Semi-transparent rounded background
                .padding(.horizontal)

                Spacer() // Pushes everything upward for symmetry
            }
        }
        .navigationTitle("Home") // Title in the navigation bar
        .onAppear {
            // Requests notification permissions on first load
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
                print("Notification permission: \(granted)")
            }
            socketManager.connect() // Connect to WebSocket for real-time updates
        }
        .onDisappear {
            socketManager.disconnect() // Clean up connection when view disappears
        }
    }
}
