#
# nb-qemu-qemu
#
# Copyright (c) 2019 Michael Goffioul
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.
#

LOCAL_PATH := $(call my-dir)

ifndef QEMU_HOST_ARCH
$(error QEMU_HOST_ARCH is not defined)
endif

ifndef QEMU_TARGET_ARCH
$(error QEMU_TARGET_ARCH is not defined)
endif

QEMU_C_INCLUDES := \
	$(LOCAL_PATH) \
	$(LOCAL_PATH)/tcg \
	$(LOCAL_PATH)/tcg/$(QEMU_HOST_ARCH) \
	$(LOCAL_PATH)/accel/tcg \
	$(LOCAL_PATH)/include

QEMU_CFLAGS := \
	-UNDEBUG -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE \
	-Wstrict-prototypes -Wredundant-decls -Wall -Wundef -Wwrite-strings \
	-Wmissing-prototypes -fno-strict-aliasing -fno-common -fwrapv -std=gnu11 \
	-Wexpansion-to-defined -Wendif-labels -Wno-shift-negative-value \
	-Wno-missing-include-dirs -Wempty-body -Wnested-externs -Wformat-security \
	-Wformat-y2k -Winit-self -Wignored-qualifiers -Wno-unused-parameter \
	-Wold-style-definition -Wtype-limits -fstack-protector-strong \
	-Wno-pointer-arith -Wno-unknown-pragmas -Werror=implicit-function-declaration \
	-Wno-missing-field-initializers -Wno-atomic-alignment -Wno-initializer-overrides \
	-Wno-string-plus-int

QEMU_CORE_SRC_FILES := \
	cpus-common.c \
	trace-root.c \
	crypto/aes.c \
	crypto/init.c \
	crypto/random-platform.c \
	disas/arm.c \
	disas/i386.c \
	hw/core/bus.c \
	hw/core/cpu.c \
	hw/core/hotplug.c \
	hw/core/irq.c \
	hw/core/qdev.c \
	hw/core/qdev-properties.c \
	hw/core/resettable.c \
	hw/core/vmstate-if.c \
	qapi/opts-visitor.c \
	qapi/qmp-event.c \
	qapi/qobject-input-visitor.c \
	qapi/qobject-output-visitor.c \
	qapi/string-input-visitor.c \
	qapi/string-output-visitor.c \
	qapi/qapi-visit-core.c \
	qapi/qapi-dealloc-visitor.c \
	qapi/qapi-clone-visitor.c \
	qapi/qapi-util.c \
	qapi/qapi-builtin-types.c \
	qapi/qapi-types-audio.c \
	qapi/qapi-types-authz.c \
	qapi/qapi-types-block-core.c \
	qapi/qapi-types-block.c \
	qapi/qapi-types-char.c \
	qapi/qapi-types-common.c \
	qapi/qapi-types-crypto.c \
	qapi/qapi-types-dump.c \
	qapi/qapi-types-error.c \
	qapi/qapi-types-introspect.c \
	qapi/qapi-types-job.c \
	qapi/qapi-types-machine.c \
	qapi/qapi-types-migration.c \
	qapi/qapi-types-misc.c \
	qapi/qapi-types-net.c \
	qapi/qapi-types-qdev.c \
	qapi/qapi-types-qom.c \
	qapi/qapi-types-rdma.c \
	qapi/qapi-types-rocker.c \
	qapi/qapi-types-run-state.c \
	qapi/qapi-types-sockets.c \
	qapi/qapi-types-tpm.c \
	qapi/qapi-types-trace.c \
	qapi/qapi-types-transaction.c \
	qapi/qapi-types-ui.c \
	qapi/qapi-builtin-visit.c \
	qapi/qapi-visit-audio.c \
	qapi/qapi-visit-authz.c \
	qapi/qapi-visit-block-core.c \
	qapi/qapi-visit-block.c \
	qapi/qapi-visit-char.c \
	qapi/qapi-visit-common.c \
	qapi/qapi-visit-crypto.c \
	qapi/qapi-visit-dump.c \
	qapi/qapi-visit-error.c \
	qapi/qapi-visit-introspect.c \
	qapi/qapi-visit-job.c \
	qapi/qapi-visit-machine.c \
	qapi/qapi-visit-migration.c \
	qapi/qapi-visit-misc.c \
	qapi/qapi-visit-net.c \
	qapi/qapi-visit-qdev.c \
	qapi/qapi-visit-qom.c \
	qapi/qapi-visit-rdma.c \
	qapi/qapi-visit-rocker.c \
	qapi/qapi-visit-run-state.c \
	qapi/qapi-visit-sockets.c \
	qapi/qapi-visit-tpm.c \
	qapi/qapi-visit-trace.c \
	qapi/qapi-visit-transaction.c \
	qapi/qapi-visit-ui.c \
	qapi/qapi-emit-events.c \
	qapi/qapi-events-audio.c \
	qapi/qapi-events-authz.c \
	qapi/qapi-events-block-core.c \
	qapi/qapi-events-block.c \
	qapi/qapi-events-char.c \
	qapi/qapi-events-common.c \
	qapi/qapi-events-crypto.c \
	qapi/qapi-events-dump.c \
	qapi/qapi-events-error.c \
	qapi/qapi-events-introspect.c \
	qapi/qapi-events-job.c \
	qapi/qapi-events-machine.c \
	qapi/qapi-events-migration.c \
	qapi/qapi-events-misc.c \
	qapi/qapi-events-net.c \
	qapi/qapi-events-qdev.c \
	qapi/qapi-events-qom.c \
	qapi/qapi-events-rdma.c \
	qapi/qapi-events-rocker.c \
	qapi/qapi-events-run-state.c \
	qapi/qapi-events-sockets.c \
	qapi/qapi-events-tpm.c \
	qapi/qapi-events-trace.c \
	qapi/qapi-events-transaction.c \
	qapi/qapi-events-ui.c \
	qobject/block-qdict.c \
	qobject/json-lexer.c \
	qobject/json-streamer.c \
	qobject/json-parser.c \
	qobject/qbool.c \
	qobject/qdict.c \
	qobject/qjson.c \
	qobject/qlist.c \
	qobject/qnull.c \
	qobject/qnum.c \
	qobject/qobject.c \
	qobject/qstring.c \
	qom/container.c \
	qom/object.c \
	qom/object_interfaces.c \
	qom/qom-qobject.c \
	stubs/cpu-get-clock.c \
	stubs/cpu-get-icount.c \
	stubs/error-printf.c \
	stubs/fdset.c \
	stubs/iothread.c \
	stubs/iothread-lock.c \
	stubs/is-daemonized.c \
	stubs/monitor.c \
	stubs/monitor-core.c \
	stubs/notify-event.c \
	stubs/replay.c \
	stubs/sysbus.c \
	stubs/vmstate.c \
	trace/control.c \
	util/bitops.c \
	util/cacheinfo.c \
	util/crc32c.c \
	util/cutils.c \
	util/envlist.c \
	util/error.c \
	util/getauxval.c \
	util/guest-random.c \
	util/host-utils.c \
	util/id.c \
	util/keyval.c \
	util/log.c \
	util/memfd.c \
	util/mmap-alloc.c \
	util/module.c \
	util/notify.c \
	util/osdep.c \
	util/oslib-posix.c \
	util/pagesize.c \
	util/path.c \
	util/qdist.c \
	util/qemu-config.c \
	util/qemu-error.c \
	util/qemu-option.c \
	util/qemu-print.c \
	util/qemu-timer-common.c \
	util/qemu-thread-posix.c \
	util/qht.c \
	util/qsp.c \
	util/range.c \
	util/rcu.c \
	util/selfmap.c \
	util/unicode.c \
	util/uuid.c

QEMU_CORE_CFLAGS := \
	$(QEMU_CFLAGS)

QEMU_CORE_C_INCLUDES := \
	$(QEMU_C_INCLUDES)

include $(CLEAR_VARS)
LOCAL_MODULE := libqemu-core
LOCAL_SRC_FILES := $(QEMU_CORE_SRC_FILES)
LOCAL_CFLAGS := $(QEMU_CORE_CFLAGS)
LOCAL_C_INCLUDES := $(QEMU_CORE_C_INCLUDES)
LOCAL_STATIC_LIBRARIES := libqemu-glib libqemu-capstone
LOCAL_EXPORT_C_INCLUDE_DIRS := \
	$(LOCAL_PATH) \
	$(LOCAL_PATH)/tcg \
	$(LOCAL_PATH)/tcg/$(QEMU_HOST_ARCH) \
	$(LOCAL_PATH)/accel/tcg \
	$(LOCAL_PATH)/include
include $(BUILD_STATIC_LIBRARY)

QEMU_TARGET_SRC_FILES := \
	disas.c \
	exec.c \
	exec-vary.c \
	gdbstub.c \
	thunk.c \
	accel/stubs/kvm-stub.c \
	accel/tcg/cpu-exec.c \
	accel/tcg/cpu-exec-common.c \
	accel/tcg/tcg-runtime.c \
	accel/tcg/tcg-runtime-gvec.c \
	accel/tcg/translator.c \
	accel/tcg/translate-all.c \
	accel/tcg/user-exec.c \
	accel/tcg/user-exec-stub.c \
	fpu/softfloat.c \
	linux-user/elfload.c \
	linux-user/exit.c \
	linux-user/fd-trans.c \
	linux-user/flatload.c \
	linux-user/gdbstub-xml.c \
	linux-user/linuxload.c \
	linux-user/main.c \
	linux-user/mmap.c \
	linux-user/signal.c \
	linux-user/strace.c \
	linux-user/syscall.c \
	linux-user/uaccess.c \
	linux-user/uname.c \
	linux-user/safe-syscall.S \
	linux-user/arm/cpu_loop.c \
	linux-user/arm/signal.c \
	linux-user/arm/semihost.c \
	linux-user/arm/nwfpe/fpa11.c \
	linux-user/arm/nwfpe/fpa11_cpdo.c \
	linux-user/arm/nwfpe/fpa11_cpdt.c \
	linux-user/arm/nwfpe/fpa11_cprt.c \
	linux-user/arm/nwfpe/fpopcode.c \
	linux-user/arm/nwfpe/single_cpdo.c \
	linux-user/arm/nwfpe/double_cpdo.c \
	linux-user/arm/nwfpe/extended_cpdo.c \
	target/arm/arm-semi.c \
	target/arm/helper.c \
	target/arm/vfp_helper.c \
	target/arm/cpu.c \
	target/arm/gdbstub.c \
	target/arm/kvm-stub.c \
	target/arm/tlb_helper.c \
	target/arm/debug_helper.c \
	target/arm/translate.c \
	target/arm/op_helper.c \
	target/arm/crypto_helper.c \
	target/arm/iwmmxt_helper.c \
	target/arm/vec_helper.c \
	target/arm/neon_helper.c \
	target/arm/m_helper.c \
	tcg/optimize.c \
	tcg/tcg.c \
	tcg/tcg-common.c \
	tcg/tcg-op.c \
	tcg/tcg-op-gvec.c \
	tcg/tcg-op-vec.c \
	trace/control-target.c \
	trace/generated-helpers.c

QEMU_TARGET_CFLAGS := \
	$(QEMU_CFLAGS) -DNEED_CPU_H -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=700

QEMU_TARGET_C_INCLUDES := \
	$(QEMU_C_INCLUDES) \
	$(LOCAL_PATH)/target/$(QEMU_TARGET_ARCH) \
	$(LOCAL_PATH)/linux-user/$(QEMU_TARGET_ARCH) \
	$(LOCAL_PATH)/linux-user/host/$(QEMU_HOST_ARCH) \
	$(LOCAL_PATH)/linux-user/

include $(CLEAR_VARS)
LOCAL_MODULE := libqemu-target
LOCAL_SRC_FILES := $(QEMU_TARGET_SRC_FILES)
LOCAL_CFLAGS := $(QEMU_TARGET_CFLAGS)
LOCAL_C_INCLUDES := $(QEMU_TARGET_C_INCLUDES)
LOCAL_STATIC_LIBRARIES := libqemu-glib libqemu-capstone
LOCAL_SHARED_LIBRARIES := libz
LOCAL_EXPORT_C_INCLUDE_DIRS := \
	$(LOCAL_PATH)/target/$(QEMU_TARGET_ARCH) \
	$(LOCAL_PATH)/linux-user/$(QEMU_TARGET_ARCH) \
	$(LOCAL_PATH)/linux-user/host/$(QEMU_HOST_ARCH) \
	$(LOCAL_PATH)/linux-user/
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := qemu-arm
LOCAL_SRC_FILES := linux-user/android-main.c
# We need the functions marked with __attribute__((constructor)), so include whole archives
LOCAL_WHOLE_STATIC_LIBRARIES := libqemu-target libqemu-core
LOCAL_STATIC_LIBRARIES := libqemu-capstone libqemu-glib
LOCAL_SHARED_LIBRARIES := libz liblog
include $(BUILD_EXECUTABLE)
