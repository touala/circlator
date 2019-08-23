# This container will install Circlator from master
#
FROM debian:testing

ENV   BUILD_DIR=/opt/circlator

# Install the dependancies
RUN   apt-get update -qq && apt-get install -y python python3-pip git wget unzip zlib1g-dev libncurses5-dev default-jre

RUN   apt-get install --yes libbz2-dev liblzma-dev

RUN   mkdir -p ${BUILD_DIR}
COPY  . ${BUILD_DIR}

RUN   cd ${BUILD_DIR} && ./install_dependencies.sh
ENV   PATH ${BUILD_DIR}/build/bwa-0.7.12:${BUILD_DIR}/build/canu-1.4/Linux-amd64/bin/:${BUILD_DIR}/build/prodigal-2.6.2:${BUILD_DIR}/build/samtools-1.3:${BUILD_DIR}/build/MUMmer3.23:${BUILD_DIR}/build/SPAdes-3.7.1-Linux/bin:$PATH
RUN   export PATH
RUN   cd ${BUILD_DIR} && python3 setup.py install

RUN   circlator progcheck

CMD   echo "Usage:  docker run -v \`pwd\`:/var/data -it <IMAGE_NAME> bash" && \
      echo "" && \
      echo "This will place you in a shell with your current working directory accessible as /var/data." && \
      echo "You can then run commands like:" && \
      echo "   circlator all /var/data/assembly.fasta /var/data/reads /var/data/<output_subdirectory>" && \
      echo "For help, please go to https://github.com/sanger-pathogens/circlator/wiki, or type" && \
      echo "   circlator --help"
