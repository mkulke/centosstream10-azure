# Centos Stream 10 w/ UEFI boot

## Requirements

- az
- jq
- qemu-img
- uv

## Build

```bash
make image.vhd
```
### Upload

```bash
make upload ACCOUNT_NAME=myaccountname BLOB_NAME=image_v123.vhd
```
