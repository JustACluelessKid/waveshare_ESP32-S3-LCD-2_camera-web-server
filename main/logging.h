#pragma once

#include "esp_log.h"

#define TAG "camera"

#define log_i(fmt, ...) ESP_LOGI(TAG, fmt, ##__VA_ARGS__)
#define log_e(fmt, ...) ESP_LOGE(TAG, fmt, ##__VA_ARGS__)
#define log_w(fmt, ...) ESP_LOGW(TAG, fmt, ##__VA_ARGS__)