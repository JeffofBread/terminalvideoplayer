
VERSION := 1.0.0
PROGRAM_NAME := tvp

ROOT_DIRECTORY := ${CURDIR}
BUILD_DIRECTORY := ${ROOT_DIRECTORY}/build
INCLUDE_DIRECTORY := ${ROOT_DIRECTORY}/inc
SOURCE_DIRECTORY := ${ROOT_DIRECTORY}/src

INCLUDES := -I${INCLUDE_DIRECTORY} -I/usr/include/ffmpeg
LIBRARIES := -lavformat -lavcodec -lavutil -lswscale
FLAGS := -std=c++17 -O3 -mtune=native -march=native -DVERSION=\"${VERSION}\" #-pedantic -Wall

SOURCE := $(addprefix ${SOURCE_DIRECTORY}/, main.cpp video.cpp)
COMPILER := g++

.DEFAULT_GOAL := all

${BUILD_DIRECTORY}:
	mkdir -p ${BUILD_DIRECTORY}

all: ${PROGRAM_NAME}
${PROGRAM_NAME}: ${BUILD_DIRECTORY}/${PROGRAM_NAME}

${BUILD_DIRECTORY}/${PROGRAM_NAME}: ${SOURCE} | ${BUILD_DIRECTORY}
	${COMPILER} ${SOURCE} ${INCLUDES} ${LIBRARIES} ${FLAGS} -o $@

clean:
	rm -f ${BUILD_DIRECTORY}/${PROGRAM_NAME}

format:
	clang-format -i --style=file ${SOURCE_DIRECTORY}/*.cpp ${INCLUDE_DIRECTORY}/*.h

ifeq ($(shell uname -s), Linux)
INSTALL_PATH := /usr/local/bin
install: all
	sudo cp -f ${BUILD_DIRECTORY}/${PROGRAM_NAME} ${INSTALL_PATH}/${PROGRAM_NAME}
.PHONY: install
endif

.PHONY: all ${PROGRAM_NAME} clean