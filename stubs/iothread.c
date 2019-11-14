#include "qemu/osdep.h"
#include "block/aio.h"
#include "qemu/main-loop.h"

AioContext *qemu_get_current_aio_context(void)
{
#ifdef __ANDROID__
    return NULL;
#else
    return qemu_get_aio_context();
#endif
}
