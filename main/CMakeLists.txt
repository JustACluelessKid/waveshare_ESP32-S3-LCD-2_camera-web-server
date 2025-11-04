idf_component_register(SRCS "main.cpp" "app_httpd.cpp" "fb_gfx/fb_gfx.cpp"
                       INCLUDE_DIRS "." "fb_gfx"
                       REQUIRES arduino esp_http_server esp32-camera esp_driver_cam esp_driver_gpio esp_timer esp_wifi)
