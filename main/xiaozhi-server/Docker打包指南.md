# Xiaozhi-Server Docker 打包指南

## 前提条件
- 确保已安装 Docker 和 Docker Compose
- 确保在 `main/xiaozhi-server` 目录下执行所有命令

## 打包方式

### 方式一：使用 Docker Compose 一键打包和启动

1. **进入项目目录**
   ```bash
   cd main/xiaozhi-server
   ```

2. **构建并启动服务**
   ```bash
   docker-compose up -d --build
   ```
   
   该命令会：
   - 根据 Dockerfile 自动构建镜像
   - 创建并启动容器
   - 后台运行服务

3. **查看服务状态**
   ```bash
   docker-compose ps
   ```

4. **查看服务日志**
   ```bash
   docker-compose logs -f xiaozhi-esp32-server
   ```

### 方式二：手动构建镜像

1. **构建镜像**
   ```bash
   docker build -t xiaozhi-esp32-server:latest .
   ```

2. **运行容器**
   ```bash
   docker run -d \
     --name xiaozhi-esp32-server \
     --restart always \
     --security-opt seccomp:unconfined \
     -e TZ=Asia/Shanghai \
     -p 8000:8000 \
     -p 8003:8003 \
     -v ./data:/opt/xiaozhi-esp32-server/data \
     -v ./models/SenseVoiceSmall/model.pt:/opt/xiaozhi-esp32-server/models/SenseVoiceSmall/model.pt \
     xiaozhi-esp32-server:latest
   ```

## 重要说明

### 文件挂载
- `./data` 目录：存放配置文件，会挂载到容器内的 `/opt/xiaozhi-esp32-server/data`
- `./models/SenseVoiceSmall/model.pt`：模型文件，必须提前下载到本地

### 端口说明
- `8000`：WebSocket 服务端口
- `8003`：HTTP 服务端口（OTA接口和视觉分析接口）

### 必要准备
在打包前确保以下文件/目录存在：
- `requirements.txt`：Python依赖文件
- `app.py`：主程序入口
- `config.yaml`：配置文件
- `data/`：数据目录
- `models/SenseVoiceSmall/model.pt`：模型文件

## 常用操作命令

### 停止服务
```bash
docker-compose down
```

### 重新构建并启动
```bash
docker-compose up -d --build --force-recreate
```

### 查看镜像
```bash
docker images | grep xiaozhi
```

### 删除镜像（重新构建前）
```bash
docker rmi xiaozhi-esp32-server:latest
```

### 进入容器调试
```bash
docker exec -it xiaozhi-esp32-server bash
```

## 故障排除

1. **构建失败**：检查网络连接，镜像源配置
2. **启动失败**：检查端口占用，文件挂载路径
3. **模型文件问题**：确保 `models/SenseVoiceSmall/model.pt` 文件存在且可读

## 推荐打包流程

1. 确保所有依赖文件就位
2. 使用 `docker-compose up -d --build` 一键构建和启动
3. 检查服务状态和日志
4. 测试服务功能是否正常 