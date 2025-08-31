# docker的使用
## 问题
- 我在拉取师兄build好的镜像时，遇到了服务器的网络问题，且由于缺少sudo权限难以解决
## **解决方案**
### 步骤一：在本地电脑操作
- 1.拉取镜像到本地电脑
```bash
docker pull yiqunchen/vqasynth:base
```
- 2.导出镜像为tar文件
```bash
docker save -o vqasynth-base.tar yiqunchen/vqasynth:base
```
- 3.压缩镜像文件（可选，减少传输时间）
```bash
gzip vqasynth-base.tar
# 或者使用更高压缩率
xz -9 vqasynth-base.tar
```
### 步骤二：传输到远程服务器
- 使用scp传输
```bash
# 如果使用gzip压缩
scp vqasynth-base.tar.gz yinchao@your-server-ip:~/

# 如果使用xz压缩
scp vqasynth-base.tar.xz yinchao@your-server-ip:~/

# 如果未压缩
scp vqasynth-base.tar yinchao@your-server-ip:~/
```
### 步骤三：在远程服务器导入镜像
首先检查文件是否传输成功：
```bash
ls -la ~/ | grep vqasynth
```
如果您已经传输了文件，可以这样导入：
```bash
# 如果是压缩文件，先解压
gunzip vqasynth-base.tar.gz
# 或者
unxz vqasynth-base.tar.xz

# 导入镜像到Docker
docker load -i vqasynth-base.tar
```
### 步骤四：验证镜像导入
```bash
docker images | grep vqasynth
```
### 步骤五：额外需要的镜像
除了主要的vqasynth:base镜像，您可能还需要以下基础镜像：

在本地电脑同时拉取这些镜像：

```bash
# 主要的NVIDIA基础镜像
docker pull nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# 可能需要的其他镜像
docker pull ubuntu:20.04
docker pull python:3.10

# 导出所有需要的镜像
docker save -o nvidia-cuda-base.tar nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04
docker save -o ubuntu-20.04.tar ubuntu:20.04
```

## 优化传输的技巧
### 1.批量导出多个镜像
```bash
docker save -o all-images.tar yiqunchen/vqasynth:base nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04 ubuntu:20.04
```
### 2.使用更好的压缩
```bash
# 使用并行压缩，速度更快
pigz all-images.tar
# 或使用最高压缩率
xz -9 -T 0 all-images.tar
```
### 3.显示传输进度
```bash
scp -v vqasynth-base.tar.gz yinchao@your-server-ip:~/
```
## 最终步骤
一旦文件传输完成，在服务器上执行：
```bash
# 解压（如果压缩了）
gunzip *.tar.gz

# 导入所有镜像
docker load -i vqasynth-base.tar
docker load -i nvidia-cuda-base.tar

# 验证导入
docker images

# 然后就可以运行VQASynth了
bash run.sh
```

