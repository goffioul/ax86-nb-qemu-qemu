#ifdef __ANDROID__

#include <signal.h>
#include <time.h>
#include <sys/types.h>
#include "qemu/osdep.h"
#include "qemu/log.h"
#include "qemu/profiler.h"
#include "qemu/thread.h"

static GHashTable *s_profiler_table = NULL;
static QemuMutex s_profiler_lock;

typedef struct {
    pid_t thread_id;
    GQueue *queue;
    uint64_t last_tick;
    uint64_t data[PROFILER_MODE_MAX];
} profiler_data_t;

static profiler_data_t *profiler_lookup()
{
  pid_t tid = gettid();
  profiler_data_t *p_data = (profiler_data_t *) g_hash_table_lookup(s_profiler_table, GINT_TO_POINTER(tid));

  if (p_data == NULL)
    {
      p_data = g_new0(profiler_data_t, 1);
      p_data->thread_id = tid;
      p_data->queue = g_queue_new();

      qemu_mutex_lock(&s_profiler_lock);
      g_hash_table_insert(s_profiler_table, GINT_TO_POINTER(tid), p_data);
      qemu_mutex_unlock(&s_profiler_lock);
    }

  return p_data;
}

static uint64_t profiler_gettick()
{
  struct timespec ts;

  if (clock_gettime(CLOCK_MONOTONIC, &ts) == 0)
    return ((uint64_t) ts.tv_sec) * 1000000ULL + ((uint64_t) ts.tv_nsec) / 1000ULL;
  return 0ULL;
}

static void profiler_dump_data(gpointer key, profiler_data_t *p_data, gpointer user_data)
{
  qemu_log("tid=%d: [0]=%-12llu [1]=%-12llu [2]=%-12llu [3]=%-12llu\n",
           p_data->thread_id, p_data->data[0], p_data->data[1], p_data->data[2], p_data->data[3]);
}

static void profiler_dump()
{
  qemu_log("Profiler data\n");
  g_hash_table_foreach(s_profiler_table, (GHFunc) profiler_dump_data, NULL);
}

static void profiler_handle_sigusr2(int num)
{
  profiler_dump();
}

void profiler_init()
{
  s_profiler_table = g_hash_table_new(g_direct_hash, g_direct_equal);
  qemu_mutex_init(&s_profiler_lock);
  signal(SIGUSR2, profiler_handle_sigusr2);
}

void profiler_start(int mode)
{
  profiler_data_t *p_data = profiler_lookup();
  uint64_t tick = profiler_gettick();
  int last_mode;

  if (! g_queue_is_empty(p_data->queue))
    {
      last_mode = GPOINTER_TO_INT(g_queue_peek_head(p_data->queue));
      p_data->data[last_mode] += (tick - p_data->last_tick);
    }
  p_data->last_tick = tick;
  g_queue_push_head(p_data->queue, GINT_TO_POINTER(mode));
}

static void inspect_queue(gpointer data, gpointer user_data)
{
  ((int*)user_data)[GPOINTER_TO_INT(data)]++;
}

void profiler_stop(int mode)
{
  profiler_data_t *p_data = profiler_lookup();
  uint64_t tick = profiler_gettick();
  int last_mode;

  if (g_queue_is_empty(p_data->queue))
    qemu_log("profiler_stop[%d]: queue is empty !!!\n", mode);
  g_assert(! g_queue_is_empty(p_data->queue));
  last_mode = GPOINTER_TO_INT(g_queue_pop_head(p_data->queue));
  if (mode != last_mode)
    {
      int counters[4] = { 0, 0, 0, 0 };
      g_queue_foreach(p_data->queue, inspect_queue, counters);
      qemu_log("profiler_stop[%d]: last = %d (length = %u) !!!\n", mode, last_mode, g_queue_get_length(p_data->queue));
      qemu_log("profiler_stop[%d]: [0]=%d, [1]=%d, [2]=%d, [3]=%d\n", mode, counters[0], counters[1], counters[2], counters[3]);
    }
  g_assert(mode == last_mode);
  p_data->data[last_mode] += (tick - p_data->last_tick);
  p_data->last_tick = tick;
}

#endif /* __ANDROID__ */
