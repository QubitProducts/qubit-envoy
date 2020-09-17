FROM envoyproxy/envoy:v1.15-latest AS builder

RUN apt-get update && apt install -y build-essential cmake
COPY jaeger-client-cpp /src/jaeger-client-cpp
WORKDIR /src/jaeger-client-cpp 
RUN mkdir build && cd build && cmake .. &&  make

FROM envoyproxy/envoy:v1.15-latest 

COPY --from=builder /src/jaeger-client-cpp/build/libjaegertracing.so /usr/local/lib/libjaegertracing.so

ENTRYPOINT ["/opt/stashdst/bin/stashdst"]
