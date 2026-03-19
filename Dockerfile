# 1. 直接引用官方已经打包好的镜像
FROM 1467078763/metapi:latest

# 2. 切换到 root 用户来修改权限（HF 运行环境限制较多）
USER root

# 3. 预创建数据目录并给最高权限，防止 SQLite 数据库写入失败
RUN mkdir -p /app/data && chmod -R 777 /app/data

# 4. 强制设置环境变量（对应你 compose 里的环境变量）
# 注意：PORT 必须是 7860，这是 HF 的硬性规定
ENV PORT=7860
ENV DATA_DIR=/app/data
ENV TZ=Asia/Shanghai
ENV CHECKIN_CRON="0 8 * * *"
ENV BALANCE_REFRESH_CRON="0 * * * *"

# 5. 暴露 HF 指定的端口
EXPOSE 7860

# 6. 切换回非 root 用户（HF 安全要求）
USER 1000

# 7. 启动命令（确保监听 0.0.0.0 和 7860 端口）
CMD ["node", "dist/index.js"]
