# VQASynth pipeline问题与解决

**运行命令**
```bash
bash run.sh
```

## 0. 环境配置
笔者已经修改了针对怀柔服务器的国内镜像源，使docker在构建的时候能够顺利构建。

详情见VQASynth/docker/base_image/Dockerfile

以及创建output目录
```bash
mkdir -p /home/yinchao/VQASynth/vqasynth_output
```

## 1. root目录磁盘空间不足

方案1：清理磁盘空间
```bash
df -h
```

方案2：清理Docker缓存和镜像
```bash
docker system prune -a -f
```

确保缓存目录存在并设置正确权限
```bash
mkdir -p /home/yinchao/hf_cache && chmod 755 /home/yinchao/hf_cache
```

## 2. 显卡使用情况
```bash
nvidia-smi

nvidia-smi --query-gpu=index,memory.used,memory.total,utilization.gpu --format=csv,noheader,nounits
```
选择占用低的显卡运行，具体选择显卡在pipelines/spatialvqa.yaml中修改。

## 3. huggingface token
```bash
cat ~/.cache/huggingface/token
```
设置自己的huggingface token

## 4. 下载flash_attn

虽然笔者已经设置了镜像源，但是速度仍然过慢，可以选择自己下载flash_attn
```bash
wget https://huggingface.co/cybertronai/flash-attn-2.6.0+cu118torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl
```
或者直接到网址 https://github.com/Dao-AILab/flash-attention/releases/tag/v2.6.0 中找到以下文件下载

```
flash_attn-2.6.0+cu118torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl
```
然后从本地电脑推送到远程服务器

```bash
scp flash_attn-2.6.0+cu118torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl yinchao@your-server-ip:~/path/to/VQASynth/
```
