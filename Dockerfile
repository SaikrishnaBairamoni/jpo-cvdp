FROM ubuntu:18.04
USER root

WORKDIR /cvdi-stream

# Add build tools.
RUN apt-get update && apt-get install -y g++

# Install cmake.
RUN apt install -y libprotobuf-dev protobuf-compiler
RUN apt install -y cmake

# Install librdkafka.
RUN apt-get install -y libsasl2-dev libsasl2-modules libssl-dev librdkafka-dev

# add the source and build files
ADD CMakeLists.txt /cvdi-stream
ADD ./src /cvdi-stream/src
ADD ./cv-lib /cvdi-stream/cv-lib
ADD ./include /cvdi-stream/include
ADD ./kafka-test /cvdi-stream/kafka-test
ADD ./unit-test-data /cvdi-stream/unit-test-data

# Do the build.
RUN export LD_LIBRARY_PATH=/usr/local/lib && mkdir /cvdi-stream-build && cd /cvdi-stream-build && cmake /cvdi-stream && make

# Add test data. This changes frequently so keep it low in the file.
ADD ./docker-test /cvdi-stream/docker-test

# Run the tool.
RUN chmod 7777 /cvdi-stream/docker-test/ppm_no_map.sh
CMD ["/cvdi-stream/docker-test/ppm_no_map.sh"]