# Centos Stream 10 w/ UEFI boot

## Requirements

### Build

- jq
- qemu-img
- uv
- dnf

### Download

- oras
- gh cli

### Upload

- az cli

## Build

```bash
make image.vhd
```

## Download

```bash
make pull-oci
```

### Upload

```bash
make upload ACCOUNT_NAME=myaccountname BLOB_NAME=image_v123.vhd
```
