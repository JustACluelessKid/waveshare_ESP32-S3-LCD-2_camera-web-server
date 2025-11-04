// board_config_waveshare.h - Configuration for Waveshare ESP32-S3-LCD-2
// Based on camera example from ESP32-S3-LCD-2-Demo

#define CAMERA_MODEL_ESP32S3_CAM_LCD

// Camera pins based on 05_lvgl_camera example
#define PWDN_GPIO_NUM    17  // power down is not used
#define RESET_GPIO_NUM   -1  // software reset will be performed
#define XCLK_GPIO_NUM    8
#define SIOD_GPIO_NUM    21  // I2C SDA
#define SIOC_GPIO_NUM    16  // I2C SCL

#define Y9_GPIO_NUM      2
#define Y8_GPIO_NUM      7
#define Y7_GPIO_NUM      10
#define Y6_GPIO_NUM      14
#define Y5_GPIO_NUM      11
#define Y4_GPIO_NUM      15
#define Y3_GPIO_NUM      13
#define Y2_GPIO_NUM      12
#define VSYNC_GPIO_NUM   6
#define HREF_GPIO_NUM    4
#define PCLK_GPIO_NUM    9

// Optional LED Flash - matching LCD backlight pin from example
#define LED_GPIO_NUM     1   // Same as EXAMPLE_PIN_NUM_BK_LIGHT

// PSRAM is available on ESP32-S3-LCD-2
#define CAMERA_PSRAM_ENABLED
