FROM plugfox/flutter:3.44.7 AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

ARG BASE_URL=http://localhost:8000/api
RUN printf 'BASE_URL=%s\n' "$BASE_URL" > .env \
    && flutter build web --release

FROM nginx:1.27-alpine AS production

COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
