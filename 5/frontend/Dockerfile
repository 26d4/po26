FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
# RUN cat /etc/nginx/conf.d/default.conf
# RUN echo "server {listen 80; location / {try_files $uri $uri/ /index.html;}}" > /etc/nginx/conf.d/spa.conf
RUN sed -i '/location \/ {/a try_files $uri $uri/ /index.html;' /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]