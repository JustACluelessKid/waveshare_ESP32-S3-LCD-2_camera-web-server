# AI Agent Instructions for ESP32-Camera-IDF Project

## Project Overview
This project is an ESP-IDF implementation of the ESP32 Camera Web Server, using Arduino as a component. It combines ESP-IDF's native capabilities with Arduino's camera libraries to create a web-based camera streaming server.

## Key Architecture Components
- `main/main.cpp`: Core application entry point, handles camera initialization and WiFi setup
- `main/app_httpd.cpp`: HTTP server implementation for camera streaming
- `main/board_config.h`: Board-specific pin configurations (points to either default AI-Thinker or Waveshare config)
- `main/camera_pins.h`: Camera pin definitions for supported boards
- `main/secrets.h`: WiFi credential configuration

## Development Environment Setup
1. ESP-IDF must be installed and properly exported:
   ```bash
   . $HOME/esp/esp-idf/export.sh
   ```
2. Arduino core must be available as a component:
   - Link it from local Arduino core: `ln -s <path-to-arduino-esp32> components/arduino`

## Board Configuration Patterns
1. ESP32 AI-Thinker (Default):
   - Use `CAMERA_MODEL_AI_THINKER` in `board_config.h`
   - Enable PSRAM in menuconfig if available
   - Set target: `idf.py set-target esp32`

2. ESP32-S3 Waveshare:
   - Include `board_config_waveshare.h` in `board_config.h`
   - Set target: `idf.py set-target esp32s3`
   - Copy full `camera_index.h` from Arduino example for web UI

## Key Integration Points
1. Camera Configuration:
   - Configuration structure in `main.cpp`
   - PSRAM-dependent settings for JPEG quality and frame buffers
   - Pixel format options: `PIXFORMAT_JPEG` (streaming) or `PIXFORMAT_RGB565` (face detection)

2. HTTP Server:
   - Implements multipart MIME streaming in `app_httpd.cpp`
   - Handles both streaming (`/stream`) and still image (`/capture`) endpoints
   - LED flash control integrated if `LED_GPIO_NUM` is defined

## Common Development Tasks
1. Building:
   ```bash
   idf.py build
   idf.py -p /dev/ttyUSB0 flash monitor
   ```

2. Configuration:
   - Use `idf.py menuconfig` for PSRAM and other ESP32-specific settings
   - Modify `secrets.h` for WiFi credentials
   - Board selection via `board_config.h`

## Error Handling Patterns
- Camera initialization failures are reported via Serial debug output
- HTTP server errors return appropriate status codes
- PSRAM detection influences camera quality settings automatically

Focus on maintaining clear separation between ESP-IDF and Arduino components while working in this codebase.