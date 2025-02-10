# 250210-cr-libvirt


- 运行示例 (已脱敏)
```bash
#!/usr/bin/env bash
# shellcheck disable=SC2317,SC2086

__main() {

  mount | grep /data/ramdisk -c || {
    mkdir -p /data/ramdisk
    mount -t tmpfs -o size=32G tmpfs /data/ramdisk
  }

  _app_data="/zfs/lwm/1420-blos"
  _app_name="$(echo "$_app_data" | awk -F/ '{print $NF}')"

  {
    # 镜像准备
    _image1="ghcr.io/lwmacct/250210-cr-libvirt:build-t2502100"
    _image2="$(docker images -q $_image1)"
    if [[ "$_image2" == "" ]]; then
      docker pull $_image1
      _image2="$(docker images -q $_image1)"
    fi
  }

  docker rm -f $_app_name 2>/dev/null || true
  docker run -itd \
    --name=$_app_name \
    --hostname=$_app_name \
    --restart=no \
    --ipc=host \
    --network=host \
    --cgroupns=host \
    --privileged=true \
    --security-opt apparmor=unconfined \
    --tmpfs /apps/data/workspace/tmpfs:rw,size=32g \
    -v /dev:/dev:rw \
    -v /sys:/sys:rw \
    -v /proc/:/host/proc \
    -v /run/:/host/run \
    -v /etc/hostid:/etc/hostid:ro \
    -v /zfs:/zfs:rw,rshared \
    -v /zfs/lwm/3333-lwmacct/data/root/.ssh:/root/.ssh \
    -v /zfs/lwm/3333-lwmacct/data/root/.docker:/root/.docker \
    -v /disk:/disk:rw,rshared \
    -v /data:/data:rw,rshared \
    -v /data/root/.ssh:/root/.ssh \
    -v /data/root/.docker:/root/.docker \
    -v "$_app_data:/apps/data" \
    -v "$_app_data/.vscode-server/root:/root" \
    -v "$_app_data/.vscode-server/data:/root/.vscode-server/data" \
    -v "$_app_data/.cursor-server/data:/root/.cursor-server/data" \
    -v cursor-server:/root/.cursor-server \
    -v vscode-server:/root/.vscode-server \
    -v vscode-root-go:/root/go \
    -v vscode-root-cache:/root/.cache \
    "$_image2"

}

__main

```