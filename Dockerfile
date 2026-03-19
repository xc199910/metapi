# 1. 引用官方镜像
FROM 1467078763/metapi:latest

# 2. 切换到 root 修复权限并创建数据目录
USER root

# 确保目录存在且 HF 的非 root 用户 (1000) 有权写入 SQLite 数据库
RUN mkdir -p /app/data && chmod -R 777 /app/data

# 3. 设置环境变量
# 必须监听 7860，这是 Hugging Face 的强制要求
ENV PORT=7860
ENV DATA_DIR=/app/data
ENV TZ=Asia/Shanghai

# 4. 暴露端口
EXPOSE 7860

# 5. 切换回非 root 用户执行 (UID 1000 是 HF 的默认用户)
USER 1000

# 6. 修正启动命令
# 根据报错，之前的 /app/dist/index.js 不存在。
# 尝试直接运行当前目录下的 index.js，并显式传入端口参数
CMD ["node", "index.js", "--port", "7860"]
