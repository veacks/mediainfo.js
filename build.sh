#!/bin/bash

# mediainfo.js
OPTS="-O2"
em++ ${OPTS} -DUNICODE -std=c++11 -I MediaInfoLib/Source -I ZenLib/Source --bind -c mediainfojs.cpp && \
em++ ${OPTS} --llvm-lto 0  -s TOTAL_MEMORY=1073741824 -s NO_FILESYSTEM=1 -s MODULARIZE=1 --bind mediainfojs.o MediaInfoLib/Project/GNU/Library/.libs/libmediainfo.a ZenLib/Project/GNU/Library/.libs/libzen.a Shared/Source/zlib/libz.a -o mediainfo.js
mv mediainfo.js mediainfo_.js
cat pre.js mediainfo_.js post.js > mediainfo.js
rm mediainfo_.js

em++ ${OPTS} -DUNICODE -std=c++11 -I MediaInfoLib/Source -I ZenLib/Source --bind -c mediainfojs.cpp && \
em++ ${OPTS} --llvm-lto 0  -s TOTAL_MEMORY=1073741824 -s NO_FILESYSTEM=1 -s BUILD_AS_WORKER=1 --bind mediainfojs.o MediaInfoLib/Project/GNU/Library/.libs/libmediainfo.a ZenLib/Project/GNU/Library/.libs/libzen.a Shared/Source/zlib/libz.a -o mediainfo_worker.js
