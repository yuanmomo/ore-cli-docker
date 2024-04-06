# 基于 Debian stable-backports 创建 Docker 镜像
FROM rust:latest as builder

# 更新包管理器并安装 gcc
RUN apt update -y && \
    apt install -y gcc  &&\
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# 安装 Solana
RUN bash -c "$(curl -sSfL https://release.solana.com/stable/install)"

RUN cargo install ore-cli


# 第二阶段：构建最终的镜像
FROM debian:stable

ENV PATH="/usr/local/cargo/bin/:${PATH}"
ENV PRC="https://api.mainnet-beta.solana.com"
ENV PRIORITY_FEE=2000
ENV THREADS=5
# 设置工作目录
WORKDIR /root

# 安装 Solana
RUN bash -c "$(curl -sSfL https://release.solana.com/stable/install)"

# 可选：如果有其他依赖，也可以复制过来
COPY --from=builder /usr/local/cargo/bin/ore /usr/local/cargo/bin/ore
COPY --from=builder /root/.bashrc /root/.bashrc

## 复制 mine.sh 到 /root 并赋予执行权限
COPY mine.sh /root/
RUN chmod +x /root/mine.sh

# 默认启动命令（可选）
CMD ["bash", "mine.sh"]
