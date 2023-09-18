FROM ubuntu:latest as build_packer

WORKDIR /build

COPY ./Syfer_V1.0/ /build/Syfer

RUN apt-get update && \
apt-get install -y \
build-essential \
libssl-dev \
publib-dev \
libmagic-dev \
libncurses-dev \
rapidjson-dev \
nasm \
gcc cmake

WORKDIR /build/Syfer
RUN make

FROM golang:latest as build_endpoint
WORKDIR /build
COPY ./endpoint /build/endpoint
WORKDIR /build/endpoint
RUN go mod tidy
RUN go build -o server .


FROM alpine:latest

WORKDIR APP

COPY --from=build_packer /build/Syfer/Syfer .
COPY --from=build_endpoint /build/endpoint/server .
#COPY Lib.so


