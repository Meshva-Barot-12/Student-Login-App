# Build only the Flutter Web application in Docker.
# Android APK builds remain available locally through Flutter/VS Code.
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.yaml ./
RUN flutter pub get

COPY . .
RUN flutter build web --release

FROM nginx:alpine AS runtime

COPY --from=build /app/build/web /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
