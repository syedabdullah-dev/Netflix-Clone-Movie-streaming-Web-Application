FROM node:20-alpine as builder
WORKDIR /app
COPY ./package.json .
COPY ./yarn.lock .
RUN yarn install
COPY . .
ARG OMDb_API_KEY
ENV VITE_APP_OMDb_API_KEY=${OMDb_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://www.OMDbapi.com"
RUN yarn build

FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/dist .
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
