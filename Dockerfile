FROM alpine

COPY ./content /workdir/

RUN apk add --no-cache curl runit bash tzdata \
    && chmod +x /workdir/service/*/run \
    && sh /workdir/install.sh \
    && rm /workdir/install.sh \
    && ln -s /workdir/service/* /etc/service/

ENV PORT=3000
ENV TZ=UTC
ENV FRP_VERSION=v0.57.0

ADD entrypoint.sh /entrypoint.sh

RUN addgroup -S frp \
 && adduser -D -S -h /var/frp -s /sbin/nologin -G frp frp \
 && apk add --no-cache curl \
 && curl -fSL https://github.com/fatedier/frp/releases/download/${FRP_VERSION}/frp_${FRP_VERSION:1}_linux_amd64.tar.gz -o frp.tar.gz \
 && tar -zxv -f frp.tar.gz \
 && rm -rf frp.tar.gz \
 && mv frp_*_linux_amd64 /frp \
 && chown -R frp:frp /frp \
 && mv /entrypoint.sh /frp/

EXPOSE 3000 7000 8080

CMD ["/frp/entrypoint.sh"]

ENTRYPOINT ["runsvdir", "/etc/service"]