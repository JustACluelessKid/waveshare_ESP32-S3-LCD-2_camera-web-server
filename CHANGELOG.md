# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]
- Add Waveshare ESP32-S3-LCD-2 board configuration and pin mapping (from ESP32-S3 demo `05_lvgl_camera`).
- Remove duplicate code block from `main/app_httpd.cpp` that caused symbol duplication.
- Add `.github/copilot-instructions.md` with AI agent-specific guidance.
- Add `.gitignore` and remove local `build/` and `build.bak/` directories.
- Add `RELEASE.md` describing build and flash steps for ESP32-S3.

## [0.1.0] - 2025-11-04
- Initial release candidate: Camera web server running under ESP-IDF with Arduino component.
