#pragma once

#include <stdint.h>
#include <stddef.h>

typedef enum {
    FB_RGB888, FB_BGR888, FB_RGB565, FB_YUV422
} fb_format_t;

typedef struct {
    uint16_t width;
    uint16_t height;
    uint16_t bytes_per_pixel;
    uint8_t format;
    uint8_t *data;
} framebuffer_t;

#ifdef __cplusplus
extern "C" {
#endif

void fb_gfx_fillRect(framebuffer_t *fb, int32_t x, int32_t y, int32_t w, int32_t h, uint32_t color);
void fb_gfx_drawFastHLine(framebuffer_t *fb, int32_t x, int32_t y, int32_t w, uint32_t color);
void fb_gfx_drawFastVLine(framebuffer_t *fb, int32_t x, int32_t y, int32_t h, uint32_t color);
uint8_t fb_gfx_putc(framebuffer_t *fb, int32_t x, int32_t y, uint32_t color, unsigned char c);
uint32_t fb_gfx_print(framebuffer_t *fb, int32_t x, int32_t y, uint32_t color, const char *str);
uint32_t fb_gfx_printf(framebuffer_t *fb, int32_t x, int32_t y, uint32_t color, const char *fmt, ...);

#ifdef __cplusplus
}
#endif