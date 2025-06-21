# 使用Python 3.10作为基础镜像
FROM python:3.10-slim

# 设置工作目录
WORKDIR /opt/xiaozhi-esp32-server

# 使用腾讯云镜像源（通常比阿里云更稳定）
RUN echo "deb https://mirrors.cloud.tencent.com/debian/ bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
    echo "deb https://mirrors.cloud.tencent.com/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.cloud.tencent.com/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    apt-get clean && \
    apt-get update

# 分步安装，避免一次安装多个包导致的失败
RUN apt-get install -y ffmpeg
RUN apt-get install -y libopus-dev
RUN apt-get install -y build-essential
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 首先只复制requirements.txt以利用Docker缓存
COPY requirements.txt .

# 安装Python依赖（使用腾讯云pip镜像源）
RUN pip install --no-cache-dir -i https://mirrors.cloud.tencent.com/pypi/simple/ -r requirements.txt

# 复制整个项目
COPY . .

# 确保数据目录存在
RUN mkdir -p data

# 暴露服务端口
EXPOSE 8000 8003

# 启动命令
CMD ["python", "app.py"] 