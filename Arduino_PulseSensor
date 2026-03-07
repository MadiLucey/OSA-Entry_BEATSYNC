#define sensor A0  // Pulse sensor connected to analog pin A0

// Variables for beat detection
int threshold = 550;      // Signal level threshold to detect a pulse
int sensorValue = 0;      // Current analog reading from the pulse sensor
int lastSensorValue = 0;  // Previous sensor reading, used to detect rising edges
bool pulseDetected = false;  // Flag to make sure each pulse is counted once

unsigned long lastBeatTime = 0;  // Timestamp of the last detected beat in milliseconds
unsigned long currentTime = 0;   // Current time (in milliseconds)
int bpm = 0;                     // Calculated Beats Per Minute (BPM)

void setup() {
  Serial.begin(9600);  // Initialize serial communication at 9600 baud for debugging and output
  delay(1000);         // Short delay to allow the sensor to stabilize
}

void loop() {
  sensorValue = analogRead(sensor);  // Read the current sensor value from analog pin A0

  currentTime = millis();  // Get the current elapsed time since program started in milliseconds

  // Detect rising edge when sensor signal crosses the threshold from below (start of a heartbeat)
  if (sensorValue > threshold && lastSensorValue <= threshold && !pulseDetected) {
    // Calculate the time interval between this beat and the previous beat
    unsigned long beatInterval = currentTime - lastBeatTime;
    lastBeatTime = currentTime;  // Update last beat timestamp to now

    // Filter out unrealistic intervals to avoid false BPM calculations
    if (beatInterval > 300 && beatInterval < 2000) {
      bpm = 60000 / beatInterval;  // Convert interval (ms) to beats per minute
    }

    pulseDetected = true;  // Mark pulse as detected to avoid multiple counts for same beat
  }

  // Reset pulseDetected flag when sensor signal drops below threshold (end of heartbeat)
  if (sensorValue < threshold) {
    pulseDetected = false;
  }

  lastSensorValue = sensorValue;  // Store current sensor value for next loop iteration

  Serial.println(bpm);  // Output BPM value to serial monitor

  delay(100);  // Delay to read sensor approximately 10 times per second (for better time resolution)
}
