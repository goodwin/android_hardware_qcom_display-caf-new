#Common headers
ifeq ($(TARGET_HAVE_NEW_GRALLOC),true)
    common_includes := hardware/qcom/display-caf-new/libgralloc
else
common_includes := hardware/qcom/display-caf-new/libgralloc-compat
ifneq ($(TARGET_NO_COMPAT_GRALLOC_PERFORM),true)
    common_flags += -DCOMPAT_GRALLOC_PERFORM
endif
endif
common_includes += hardware/qcom/display-caf-new/liboverlay
common_includes += hardware/qcom/display-caf-new/libcopybit
common_includes += hardware/qcom/display-caf-new/libqdutils
common_includes += hardware/qcom/display-caf-new/libhwcomposer
common_includes += hardware/qcom/display-caf-new/libexternal
common_includes += hardware/qcom/display-caf-new/libqservice
common_includes += hardware/qcom/display-caf-new/libvirtual

ifeq ($(TARGET_USES_POST_PROCESSING),true)
    common_flags     += -DUSES_POST_PROCESSING
    common_includes  += $(TARGET_OUT_HEADERS)/pp/inc
endif

common_header_export_path := qcom/display-caf-new

#Common libraries external to display HAL
common_libs := liblog libutils libcutils libhardware

#Common C flags
common_flags += -DDEBUG_CALC_FPS -Wno-missing-field-initializers
#TODO: Add -Werror back once all the current warnings are fixed
common_flags += -Wconversion -Wall

ifeq ($(ARCH_ARM_HAVE_NEON),true)
    common_flags += -D__ARM_HAVE_NEON
endif

ifeq ($(call is-board-platform-in-list, msm8974 msm8226 msm8610 apq8084 \
        mpq8092 msm_bronze msm8916), true)
    common_flags += -DVENUS_COLOR_FORMAT
    common_flags += -DMDSS_TARGET
endif

common_deps  :=
kernel_includes :=

ifeq ($(TARGET_DEVICE),hammerhead)
    common_flags += -DHAMMERHEAD_PIXEL_FORMAT
endif

# Executed only on QCOM BSPs
ifeq ($(TARGET_USES_QCOM_BSP),true)
# Enable QCOM Display features
    common_flags += -DQCOM_BSP
endif
ifneq ($(call is-platform-sdk-version-at-least,18),true)
    common_flags += -DANDROID_JELLYBEAN_MR1=1
endif
ifeq ($(call is-vendor-board-platform,QCOM),true)
# This check is to pick the kernel headers from the right location.
# If the macro above is defined, we make the assumption that we have the kernel
# available in the build tree.
# If the macro is not present, the headers are picked from hardware/qcom/msmXXXX
# failing which, they are picked from bionic.
    common_deps += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
    kernel_includes += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
endif
