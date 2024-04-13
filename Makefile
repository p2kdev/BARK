export THEOS_PACKAGE_SCHEME=rootless
export TARGET = iphone:clang:13.7:13.0

PACKAGE_VERSION=$(THEOS_PACKAGE_BASE_VERSION)

THEOS_DEVICE_IP = 192.168.86.37

include $(THEOS)/makefiles/common.mk
export TARGET = iphone:clang:13.7:13.0

TWEAK_NAME = BARK
BARK_CFLAGS = -fobjc-arc
BARK_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"
