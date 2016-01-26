# mjpg-streamer

```
docker run \
    -d \
    -p 8080:8080 \
    --device=/dev/video0 \
    --name mjpg-streamer mjpg-streamer
```
