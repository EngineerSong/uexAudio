#!/bin/sh

###########################################################################
#  Change values here													  #
#																		  #
VERSION="0.1.2"		  											          #
SDKVERSION="4.2"														  #
#																		  #
###########################################################################
#																		  #
# Don't change anything under this line!								  #
#																		  #
###########################################################################

#opencore-amr-0.1.2

CURRENTPATH=`pwd`

mkdir -p "${CURRENTPATH}/src"
tar zxf opencore-amr-${VERSION}.tar.gz -C "${CURRENTPATH}/src"
cd "${CURRENTPATH}/src/opencore-amr-${VERSION}"

############
# iPhone Simulator
echo "Building opencore-amr for iPhoneSimulator ${SDKVERSION} i386"
echo "Please stand by..."

mkdir -p "${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}.sdk"
LOG="${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}.sdk/build-openamr-${VERSION}.log"

SDK=/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator${SDKVERSION}.sdk
export CC ="/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/gcc -arch i386"
CXX="/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/g++ -arch i386"
LDFLAGS="-Wl,-syslibroot,$SDK" 
./configure --disable-shared --prefix="${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}.sdk"

make >> "${LOG}" 2>&1
make install >> "${LOG}" 2>&1
make clean >> "${LOG}" 2>&1
#############

#############
# iPhoneOS armv6
echo "Building opencore-amr for iPhoneOS ${SDKVERSION} armv6"
echo "Please stand by..."

mkdir -p "${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv6.sdk"
LOG="${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv6.sdk/build-openamr-${VERSION}.log"

SDK=/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${SDKVERSION}.sdk
export CC ="/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc -arch armv6 --sysroot=$SDK"
export CXX="/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/g++ -arch armv6 --sysroot=$SDK"
LDFLAGS="-Wl,-syslibroot,$SDK"
./configure --host=arm-apple-darwin --target=darwin --prefix="${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv6.sdk" --disable-shared

make >> "${LOG}" 2>&1
make install >> "${LOG}" 2>&1
make clean >> "${LOG}" 2>&1
#############

#############
# iPhoneOS armv7
echo "Building opencore-amr for iPhoneOS ${SDKVERSION} armv7"
echo "Please stand by..."

mkdir -p "${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv7.sdk"
LOG="${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv7.sdk/build-openamr-${VERSION}.log"

SDK=/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${SDKVERSION}.sdk
export CC="/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc -arch armv7 --sysroot=$SDK"
CXX="/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/g++ -arch armv7 --sysroot=$SDK"
LDFLAGS="-Wl,-syslibroot,$SDK"
./configure --host=arm-apple-darwin --target=darwin --prefix="${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv7.sdk" --disable-shared 

make >> "${LOG}" 2>&1
make install >> "${LOG}" 2>&1
make clean >> "${LOG}" 2>&1
#############


echo "Build library..."
mkdir -p ${CURRENTPATH}/lib
lipo -create ${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}.sdk/lib/libopencore-amrwb.a ${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv6.sdk/lib/libopencore-amrwb.a ${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv7.sdk/lib/libopencore-amrwb.a -output ${CURRENTPATH}/lib/libopencore-amrwb.a

lipo -create ${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}.sdk/lib/libopencore-amrnb.a ${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv6.sdk/lib/libopencore-amrnb.a ${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv7.sdk/lib/libopencore-amrnb.a -output ${CURRENTPATH}/lib/libopencore-amrnb.a


mkdir -p ${CURRENTPATH}/include
cp -R ${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}.sdk/include ${CURRENTPATH}/include/
echo "Building done."
echo "Cleaning up..."
rm -rf ${CURRENTPATH}/src
rm -rf ${CURRENTPATH}/bin
echo "Done."
