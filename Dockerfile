FROM trzeci/emscripten:latest
RUN apt-get update -y && apt-get install libtool automake autoconf m4 pkgconf -y

RUN mkdir /app

WORKDIR /app

COPY ./ /app

# zlib
RUN mkdir -p Shared/Source
RUN wget http://zlib.net/zlib-1.2.11.tar.gz -q -O - | tar -xz -C Shared/Source
RUN mv Shared/Source/zlib-1.2.11 Shared/Source/zlib

WORKDIR /app/Shared/Source/zlib
RUN emconfigure ./configure
RUN emmake make

# Zenlib
WORKDIR /app
RUN wget https://mediaarea.net/download/source/libzen/0.4.32/libzen_0.4.32.tar.bz2 -q -O - | tar -xj
WORKDIR /app/ZenLib/Project/GNU/Library/
RUN ./autogen.sh
RUN emconfigure ./configure --host=le32-unknown-nacl
RUN emmake make


# MediaInfoLib
WORKDIR /app
RUN wget https://mediaarea.net/download/source/libmediainfo/19.04/libmediainfo_19.04.tar.bz2 -q -O - | tar -xj
WORKDIR /app/MediaInfoLib/Project/GNU/Library
RUN ./autogen.sh
RUN emconfigure ./configure --with-libz-static --host=le32-unknown-nacl
RUN emmake make

# Build emscripten
WORKDIR /app
RUN ./build.sh