UVX_BIN := $(shell which uvx)
MKOSI_SHA := 9a28ad20bbea61894ea7b971d318a71f4374cf3b
ACCOUNT_NAME ?= replace_me
CONTAINER_NAME := vhd
BLOB_NAME ?= centos10_uefi.vhd

.PHONY: upload

image.raw: mkosi.conf
	$(UVX_BIN) \
		--from git+https://github.com/systemd/mkosi.git#$(MKOSI_SHA) \
		mkosi --force && \
	./resize.sh

image.vhd: image.raw
	qemu-img convert -f raw -o subformat=fixed,force_size -O vpc \
		image.raw \
		image.vhd

upload: image.vhd
	az storage blob upload \
		--file image.vhd \
		--container-name vhd \
		--account-name $(ACCOUNT_NAME) \
		--name $(BLOB_NAME)
