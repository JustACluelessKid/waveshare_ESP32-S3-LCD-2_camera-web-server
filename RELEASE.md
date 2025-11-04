RELEASE

Target: esp32s3

Notes
- This repo packages the Arduino CameraWebServer example for ESP-IDF.
- Target board: Waveshare ESP32-S3-LCD-2 (ESP32-S3). Ensure `main/board_config.h` selects the correct mapping (a Waveshare mapping is provided in `main/board_config_waveshare.h`).
- PSRAM: Enable external PSRAM for higher JPEG quality and framebuffers (Component config -> ESP32S3-specific -> Support for external RAM).

Build & flash (Linux)
1. Install and source ESP-IDF (adjust path if you installed elsewhere):

```bash
# from your shell
. $HOME/esp/esp-idf/export.sh
# RELEASE

Target: esp32s3

## v1.0.0 — Initial release

This release contains the Waveshare ESP32-S3-LCD-2 port of the Camera Web Server adapted to work under ESP-IDF with the Arduino core used as a component. It includes the adapted `main` sources, `app_httpd.cpp` (camera HTTP server), board pin mappings for the Waveshare board, and a tested build/flash workflow.

Note: some example assets (for example, the full `camera_index.h` from the Arduino example) are intentionally left out of this repository; see `README.md` for instructions on copying them in if you want the full web UI.

Important: this will most likely be the only release for this repository. The project is maintained as a single snapshot port and may not receive future release versions. If you need ongoing updates or feature work, consider forking the repo and maintaining your own release cadence.

### Build & flash (Linux)

1. Install and source ESP-IDF (adjust path if you installed elsewhere):

```bash
# from your shell
. $HOME/esp/esp-idf/export.sh
```

2. Add Arduino-ESP32 as a component (this repository doesn't include the full Arduino core):

```bash
# from repo root
ln -s /path/to/arduino-esp32 components/arduino
```

3. Set target and configure:

```bash
idf.py set-target esp32s3
idf.py menuconfig   # enable PSRAM if present
```

4. Build and flash:

```bash
idf.py build
idf.py -p /dev/ttyACM0 flash monitor
```

### Web UI notes
- The project embeds compressed web UI pages in `main/camera_index.h`. The HTTP server in `main/app_httpd.cpp` serves the appropriate page based on the detected camera PID.
- If your camera is OV5640 and the build fails with an undefined symbol like `index_ov5640_html_gz`, copy the full `camera_index.h` from the Arduino CameraWebServer example into `main/`.

### Misc
- `main/secrets.h` must be updated with your Wi‑Fi credentials before building.
- This release cleans up local build artifacts and fixes a duplicate block in `main/app_httpd.cpp` that previously caused duplicated symbols.

---

This file documents the initial release snapshot and accompanying notes.
