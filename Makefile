KDIR ?= /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)
MODDIR ?= /lib/modules/$(shell uname -r)/updates

.PHONY: all clean install

all:
	$(MAKE) -C $(KDIR) M=$(PWD)/drivers/thunderbolt modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD)/drivers/thunderbolt clean

install: all
	install -Dm0644 $(PWD)/drivers/thunderbolt/thunderbolt.ko $(MODDIR)/thunderbolt.ko
	depmod -a
