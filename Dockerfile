ARG   BASE_IMAGE=wmoore28/batchspawner-pyroot-notebook:1.0.0
FROM  $BASE_IMAGE

LABEL maintainer "Nick Tyler <tylern@jlab.org>"
USER root

# Setup env for clas12root
ARG CLAS12ROOT_VERSION=1.7.2
ENV CLAS12ROOT /usr/local/clas12root
ENV PATH $PATH:$CLAS12ROOT/bin

#To use the RCDB interface 
ENV RCDB_HOME $CLAS12ROOT/rcdb
#To use the CCDB interface 
ENV CCDB_HOME $CLAS12ROOT/ccdb
ENV LD_LIBRARY_PATH=$CCDB_HOME/lib:$LD_LIBRARY_PATH
ENV PYTHONPATH=$CCDB_HOME/python:$CCDB_HOME/python/ccdb/ccdb_pyllapi/:$PYTHONPATH
ENV PATH=$CCDB_HOME/bin:$PATH
#To use clasqaDB interface
ENV QADB $CLAS12ROOT/clasqaDB


# Build and install clas12root
RUN git clone --recurse-submodules --single-branch --branch ${CLAS12ROOT_VERSION} \
    https://github.com/jeffersonlab/clas12root.git ${CLAS12ROOT} \
    && mkdir -p ${CLAS12ROOT}/build \
    && cd ${CLAS12ROOT}/build \
    && cmake .. \
    && make -j$(nproc) \
    && cmake .. \
    && make install

USER $NB_UID
