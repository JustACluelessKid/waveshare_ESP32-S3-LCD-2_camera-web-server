# ESP32 Camera — Waveshare ESP32-S3-LCD-2 (ESP-IDF + Arduino component)

IMPORTANT: This repository has been adapted specifically for the Waveshare ESP32-S3-LCD-2 (ESP32-S3) board. If you are using a different board (for example AI-Thinker ESP32 modules), you'll need to adjust the board pin mappings in `main/board_config.h`, confirm PSRAM settings in `menuconfig`, and possibly replace `camera_index.h` with the appropriate web UI assets.

This project is a minimal wrapper to run the Arduino `CameraWebServer` example under ESP-IDF using the Arduino core as a component, with Waveshare-specific pin mappings and configuration.

Files created:
- `main/main.cpp` - converted sketch (with `app_main` wrapper)
- `main/app_httpd.cpp` - camera HTTP server helper (copied from Arduino example)
- `main/camera_pins.h` - pin definitions for supported camera boards
- `main/board_config.h` - selects `CAMERA_MODEL_AI_THINKER`
- `main/secrets.h` - WiFi credentials placeholder

Quick start (Linux):

1. Make sure you have ESP-IDF installed and exported:

```bash
. $HOME/esp/esp-idf/export.sh
```

2. In the project root create a symlink to your local Arduino core (this workspace doesn't include the full Arduino component):

```bash
ln -s /home/maxgn/Downloads/arduino-esp32-master components/arduino
```

3. Set target and enable PSRAM if your AI-Thinker board has PSRAM:

```bash
idf.py set-target esp32
idf.py menuconfig   # Component config -> ESP32-specific -> enable external PSRAM if present
```

4. Build and flash:

```bash
# Set the serial port you will use (example values shown)
PORT=/dev/ttyACM0  # or /dev/ttyUSB0

idf.py build
idf.py -p "$PORT" flash monitor
```

Notes:
- Replace `main/secrets.h` with your actual SSID and password before building.
- If the build complains about missing dependencies from the Arduino core, ensure the `components/arduino` symlink points to a full Arduino-ESP32 checkout.

ESP32-S3 / Waveshare ESP32-S3-LCD-2 notes
--------------------------------------

If you are building for a Waveshare ESP32-S3-LCD-2 (ESP32-S3) board do the following:

1) Set IDF target to esp32s3:

```bash
idf.py set-target esp32s3
```

2) If your board has external PSRAM enable it in `menuconfig` (Component config -> ESP32-specific -> enable external PSRAM).

3) Choose the Waveshare board camera mapping by editing `main/board_config.h` to include `board_config_waveshare.h` or replace its contents with:

```cpp
// For Waveshare ESP32-S3-LCD-2
#include "board_config_waveshare.h"
```

4) The example `app_httpd.cpp` expects `camera_index.h` (large compressed HTML arrays). You can copy the full `camera_index.h` from the Arduino example into `main/` so the web UI is served:

```
cp /home/maxgn/Downloads/arduino-esp32-master/libraries/ESP32/examples/Camera/CameraWebServer/camera_index.h main/
```

Or keep the provided `main/camera_index.h` stub (it declares the symbols) and later replace it with the full file to enable the web UI.

5) Build & flash as usual (after linking the Arduino component):

```bash
. $HOME/esp/esp-idf/export.sh
# from project root
ln -s /home/maxgn/Downloads/arduino-esp32-master components/arduino
# Set serial port before flashing, e.g.:
PORT=/dev/ttyACM0   # or /dev/ttyUSB0
idf.py build
idf.py -p "$PORT" flash monitor
```

Getting started (tested commands)
--------------------------------

The commands below were tested when building/flashing for the Waveshare ESP32-S3-LCD-2 on this machine. Run them from the project root and adjust paths/ports as needed.

```bash
# Export your ESP-IDF environment (adjust path if your IDF is elsewhere)
. /home/maxgn/esp/v5.5.1/esp-idf/export.sh

# Link your local Arduino core (only needed if you don't already have a components/arduino)
ln -s /home/maxgn/Downloads/arduino-esp32-master components/arduino

# Ensure target is esp32s3 (Waveshare board)
idf.py set-target esp32s3

# Build
idf.py build

# Flash to the Waveshare board and open the monitor (replace port if different)
idf.py -p /dev/ttyACM0 flash monitor
```

Notes:
- The build on this workspace created `build/esp32_camera_webserver.bin`. The application partition reported about 1% free space — consider using a larger app partition or trimming components if you need OTA headroom.
- Replace `main/secrets.h` with your Wi‑Fi credentials before building.