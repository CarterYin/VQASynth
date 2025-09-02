#!/bin/bash

CONFIG_FILE=./config/config.yaml

OUTPUT_DIR=$(yq e '.directories.output_dir' $CONFIG_FILE)
HF_TOKEN=$(cat ~/.cache/huggingface/token)

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: Local output directory specified in config.yaml does not exist."
    exit 1
fi

export OUTPUT_DIR="$OUTPUT_DIR"
export HF_TOKEN="$HF_TOKEN"

# 设置Hugging Face镜像源和缓存目录到有空间的分区
export HF_ENDPOINT="https://hf-mirror.com"
export HF_HUB_URL="https://hf-mirror.com"
export HF_DATASETS_CACHE="/home/yinchao/hf_cache"

# 设置更长的超时时间和重试次数
export HF_HUB_DOWNLOAD_TIMEOUT=300
export HF_HUB_DOWNLOAD_RETRY=5
export HF_HUB_DOWNLOAD_CHUNK_SIZE=1048576

# 创建缓存目录
mkdir -p /home/yinchao/hf_cache

echo "Building base image..."
docker build -f docker/base_image/Dockerfile -t vqasynth:base .

echo "Launching pipeline"
docker compose -f pipelines/spatialvqa.yaml up --build
