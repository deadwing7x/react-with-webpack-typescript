FROM node:10-alpine as builder

WORKDIR /var/www/cdn/current

COPY package.json package-lock.json ./

# Install dependencies
RUN npm install 

COPY . .

# Build the project
RUN npm run webpack


FROM nginx:alpine

#!/bin/sh

COPY ./.nginx/nginx.conf /etc/nginx/nginx.conf

# Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy from the stahg 1
COPY --from=builder /var/www/cdn/current/build /usr/share/nginx/html

EXPOSE 8000 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]