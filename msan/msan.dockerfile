FROM base

COPY exclude.txt .

# llvm-symbolizer
RUN apt-get update && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y llvm-10

RUN mkdir -p /msan/build/

RUN git clone --depth=1 https://github.com/llvm/llvm-project -b llvmorg-10.0.0 /msan/llvm-project

RUN cd /msan/build && \
    cmake -DLLVM_ENABLE_PROJECTS='libcxx;libcxxabi' \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_USE_SANITIZER=MemoryWithOrigins \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLLVM_TARGETS_TO_BUILD=X86 \
    ../llvm-project/llvm/ && \
    make cxx -j6

ENV LIBCXX_DIR /msan/build/
ENV MSAN_FLAGS "-fsanitize=memory -fsanitize-memory-track-origins=2 -fno-omit-frame-pointer -fno-optimize-sibling-calls"
ENV LIBCXX_FLAGS "-nostdinc++ -stdlib=libc++ -L${LIBCXX_DIR}lib -lc++abi -I${LIBCXX_DIR}include -I${LIBCXX_DIR}include/c++/v1 -lpthread -Wl,-rpath,${LIBCXX_DIR}lib"
ENV MSAN_AND_LIBCXX_FLAGS "${MSAN_FLAGS} ${LIBCXX_FLAGS} -g -O1 -Wno-unused-command-line-argument"

WORKDIR /bitcoin/