import Foundation
import UserNotifications // For sending local notifications

// ObservableObject allows this class to be used with SwiftUI views that observe it
class WebSocketManager: ObservableObject {
    @Published var bpm: String = "--" // Publishes changes to the heart rate string to update UI

    private var task: URLSessionWebSocketTask? // Manages the WebSocket connection
    private var isAbnormal = false // Tracks whether the BPM is outside the normal range
    private var alertTimer: Timer? // Timer that periodically checks for abnormal BPM

    // Establishes a WebSocket connection
    func connect() {
        // Ensure the WebSocket URL is valid
        guard let url = URL(string: "ws://172.20.10.3:6789") else {
            print("Invalid WebSocket URL")
            return
        }

        // Create and start a WebSocket task
        let session = URLSession(configuration: .default)
        task = session.webSocketTask(with: url)
        task?.resume()

        print("WebSocket connected to \(url)")

        startAlertTimer() // Start periodic abnormality check
        receive()         // Begin listening for incoming messages
    }

    // Disconnects the WebSocket and stops the timer
    func disconnect() {
        task?.cancel(with: .goingAway, reason: nil) // Close the connection
        alertTimer?.invalidate() // Stop the alert timer
        print("WebSocket disconnected")
    }

    // Continuously receives messages from the WebSocket server
    private func receive() {
        task?.receive { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    switch message {
                    case .string(let text): // Received a text message
                        print("Received text: \(text)")
                        // Show "Connecting..." while no real data is coming in
                        self?.bpm = text == "0" ? "Connecting..." : text
                        self?.checkAbnormal(bpm: text) // Check if the BPM is abnormal
                    case .data(let data): // Received binary data (not used)
                        print("Received binary data: \(data)")
                    @unknown default: // Fallback for future message types
                        print("Unknown message type received")
                    }
                case .failure(let error): // WebSocket error
                    print("WebSocket error: \(error)")
                }

                // Recursively listen for the next message
                self?.receive()
            }
        }
    }

    // Determines whether the current BPM is abnormal (too low or too high)
    private func checkAbnormal(bpm: String) {
        guard let value = Int(bpm) else { return }
        isAbnormal = value < 40 || value > 100 // Define abnormal range
    }

    // Starts a timer that checks the BPM every 30 seconds and sends a notification if abnormal
    private func startAlertTimer() {
        alertTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.isAbnormal, let currentBpm = Int(self.bpm) {
                self.sendNotification(title: "BPM Alert", body: "Heart rate is \(currentBpm) BPM")
            }
        }
    }

    // Sends a local notification using the UserNotifications framework
    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default // Use default system sound

        // Trigger notification immediately
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            } else {
                print("Notification scheduled")
            }
        }
    }
}
