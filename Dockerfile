
FROM nginx

ARG MANAGER_IP
ARG WORKER_IP

COPY default.conf.template /etc/nginx/conf.d/default.conf.template

COPY nginx.conf /etc/nginx/nginx.conf

RUN envsubst '${MANAGER_IP} ${WORKER_IP}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

CMD ["nginx", "-g", "daemon off;"]
