# [Docker Lsky Pro Enterprise](https://github.com/Xm798/docker-lsky-pro-enterprise)

[![Lsky Pro](https://docs.lsky.pro/logo.png)](https://github.com/Xm798/docker-lsky-pro-enterprise)

Lsky Pro 企业版的 Docker 镜像。

## Usage

> [!TIP]
> 推荐使用 docker-compose 进行部署

一个包含 lsky-pro、mariadb 和 redis 的 compose file 示例如下：

```yaml
version: "3"

services:
  lsky-pro:
    depends_on:
      - db
      - redis
    build: ./
    container_name: lsky-pro
    volumes:
      - "./config:/config"
    ports:
      - "80:80"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - REDIS_HOST=redis
      - APP_SERIAL_NO=YOUR_SERIAL_NO
      - APP_SECRET=YOUR_APP_SECRET
      - APP_URL=https://your.url.com

  db:
    image: mariadb:latest
    container_name: lsky-pro-db
    volumes:
      - ./data/db:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: lsky-pro
      MYSQL_DATABASE: lsky-pro
      MYSQL_USER: lsky-pro
      MYSQL_PASSWORD: lsky-pro
    healthcheck:
      test: [ "CMD", "healthcheck.sh", "--su-mysql", "--connect", "--innodb_initialized" ]
      start_period: 30s
      interval: 1m
      timeout: 5s
      retries: 3

  redis:
    image: redis:7-alpine
    container_name: lsky-pro-redis
    restart: always
    volumes:
      - ./data/redis:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      start_period: 30s
      interval: 1m
      timeout: 5s
      retries: 3
```

请克隆本仓库，并将官方下载的 Lsky Pro 企业版代码包重命名为 lsky-pro.zip，放置于仓库根目录下，然后执行本地构建。

>[!IMPORTANT]
> 中国大陆用户可以将`Dockerfile` 中的 `xm798/lsky-pro-enterprise-baseimage:latest` 镜像修改为 `registry.cn-shanghai.aliyuncs.com/lsky-pro-enterprise-baseimage:latest`，以加快构建速度。

```bash
docker compose build
```

## 参数

- 端口：容器内部使用 80 作为服务端口，如果需要使用 ssl，需要映射内部端口 443
- 目录：容器数据挂载在 `/config` 内部目录中
- PUID / PGID：UserID / GroupID
- REDIS_HOST：redis 主机，使用该 compose 示例需要设置为 `redis`
- APP_SERIAL_NO：序列号
- APP_SECRET：许可证密钥
- APP_URL：站点域名

> [!TIP]
> `.env.example` 中的其他变量均可使用环境变量进行覆盖。

## 用户/组标识符

当使用主机卷时，主机操作系统与容器之间可能会出现权限问题，可以通过指定用户 PUID 和组 PGID 来避免此问题。详情可阅读 [Understanding PUID and PGID - LinuxServer.io](https://docs.linuxserver.io/general/understanding-puid-and-pgid/)。

确保主机上的任何卷目录都由你指定的同一用户拥有，上面的例子中设置为 `PUID=1000` 和 `PGID=1000`。可以通过 `id your_user` 查看 user 用户的 uid 和 gid:

```bash
id your_user
```

Example output:

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```
