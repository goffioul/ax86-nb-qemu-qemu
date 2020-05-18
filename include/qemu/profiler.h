#ifdef __ANDROID__

#ifndef QEMU_PROFILER_H
#define QEMU_PROFILER_H

#define PROFILER_MODE_CPU_LOOP 0
#define PROFILER_MODE_TCG_GEN  1
#define PROFILER_MODE_TB_EXEC  2
#define PROFILER_MODE_SYSCALL  3
#define PROFILER_MODE_MAX      4

void profiler_init(void);
void profiler_start(int mode);
void profiler_stop(int mode);

#endif /* QEMU_PROFILER_H */

#endif /* __ANDROID__ */
