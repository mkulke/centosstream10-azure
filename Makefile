MKOSI_SHA := 9a28ad20bbea61894ea7b971d318a71f4374cf3b
ACCOUNT_NAME ?= replace_me
CONTAINER_NAME := vhd
BLOB_NAME ?= centos10_uefi.vhd
GIT_SHA := $(shell git rev-parse HEAD)
OCI_REG := ghcr.io/mkulke/centosstream10-azure/vhd
OCI_TAG ?= sha-$(shell echo $(GIT_SHA) | head -c 12)

.PHONY: upload pull-oci
.SECONDARY: image.raw

image.raw: mkosi.conf
	uv tool run \
		--from git+https://github.com/systemd/mkosi.git#$(MKOSI_SHA) \
		mkosi --force && \
	./resize.sh

image.vhd: image.raw
	qemu-img convert -f raw -o subformat=fixed,force_size -O vpc \
		image.raw \
		image.vhd

pull-oci:
	$(eval OCI_SHA := $(shell oras resolve $(OCI_REG):$(OCI_TAG)))
	$(eval OCI_REPO := $(OCI_REG)@$(OCI_SHA))
	gh attestation verify oci://$(OCI_REPO) \
		--repo mkulke/centosstream10-azure \
		--deny-self-hosted-runners \
		--source-digest $(GIT_SHA) \
		--signer-digest $(GIT_SHA) && \
	oras pull $(OCI_REPO)

upload: image.vhd
	az storage blob upload \
		--file image.vhd \
		--container-name vhd \
		--account-name $(ACCOUNT_NAME) \
		--name $(BLOB_NAME)
