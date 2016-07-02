#!/bin/bash

#
# See http://wiki.osdev.org/GCC_Cross-Compiler
#

export ROOT=`pwd`/crosscompiler
export SRC_DIR=$ROOT/sources
export BUILD_DIR=$SRC_DIR/build
export TOOLS=$ROOT/tools
export PATH=$TOOLS/bin:$PATH
export SYS_TGT=$(uname -m)-cross-linux-gnu

CLEAN=''

while getopts 'c' flag; do
  case "${flag}" in
    c) CLEAN='true' ;;
  esac
done

if [ "$CLEAN" = true ] ; then
    echo -n "Removing build dir..."
    rm -rf $BUILD_DIR
fi

function prepare_src {
  tar -xf $SRC_DIR/$1 -C $BUILD_DIR
  pushd $BUILD_DIR/$2
}

mkdir -pv $SRC_DIR $ROOT $TOOLS $BUILD_DIR

urllist=(
  http://ftp.gnu.org/gnu/binutils/binutils-2.25.1.tar.bz2
  http://www.mpfr.org/mpfr-3.1.3/mpfr-3.1.3.tar.xz
  http://ftp.gnu.org/gnu//gmp/gmp-6.0.0a.tar.xz
  http://www.multiprecision.org/mpc/download/mpc-1.0.3.tar.gz
  http://ftp.gnu.org/gnu/gcc/gcc-4.9.3/gcc-4.9.3.tar.bz2
  https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.4.14.tar.xz
  )

for url in ${urllist[@]}; do
  wget -P $SRC_DIR --progress=bar -nc -c $url
done

export MAKEFLAGS='-j 4'

prepare_src binutils-2.25.1.tar.bz2 binutils-2.25.1
mkdir -v $BUILD_DIR/binutils-build
cd $BUILD_DIR/binutils-build
$BUILD_DIR/binutils-2.25.1/configure     \
    --prefix=$TOOLS            \
    --with-sysroot             \
    --with-lib-path=$TOOLS/lib \
    --target=$SYS_TGT          \
    --disable-nls              \
    --disable-werror
make

case $(uname -m) in
  x86_64) mkdir -v $TOOLS/lib && ln -sv lib $TOOLS/lib64 ;;
esac

make install

popd

prepare_src linux-4.4.14.tar.xz linux-4.4.14
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* $TOOLS/include


popd


prepare_src gcc-4.9.3.tar.bz2 gcc-4.9.3
prepare_src mpfr-3.1.3.tar.xz .
mv -v mpfr-3.1.3 gcc-4.9.3/mpfr
prepare_src gmp-6.0.0a.tar.xz .
mv -v gmp-6.0.0 gcc-4.9.3/gmp
prepare_src mpc-1.0.3.tar.gz .
mv -v mpc-1.0.3 gcc-4.9.3/mpc

pushd $BUILD_DIR/gcc-4.9.3

for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@$TOOLS&@g' \
      -e 's@/usr@$TOOLS@g' $file.orig > $file
  echo "
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 \"$TOOLS/lib/\"
#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $file
  touch $file.orig
done

mkdir -v $BUILD_DIR/gcc-build
cd $BUILD_DIR/gcc-build

$BUILD_DIR/gcc-4.9.3/configure                     \
    --target=$SYS_TGT                              \
    --prefix=$TOOLS                                \
    --enable-languages=c,c++                       \
    --without-headers                              \
    --with-build-sysroot=$TOOLS                               \
    --disable-nls                                  
#    --disable-shared                               \
#    --enable-multilib                             \
#    --disable-threads                              \
#    --enable-interwork
#    --with-sysroot=$ROOT                           \

#make BOOT_CFLAGS='-O' bootstrap
#make
#make install
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc


#popd
#prepare_src linux-4.2.tar.xz linux-4.2
#make INSTALL_HDR_PATH=dest headers_install
#cp -rv dest/include/* $TOOLS/include


#popd
#prepare_src glibc-2.22.tar.xz glibc-2.22
#patch -Np1 -i $SRC_DIR/glibc-2.22-upstream_i386_fix-1.patch
#mkdir -v $BUILD_DIR/glibc-build
#cd $BUILD_DIR/glibc-build

#../glibc-2.22/configure                             \
#      --prefix=$TOOLS                               \
#      --host=$SYS_TGT                               \
#      --build=$($SRC_DIR/glibc-2.22/scripts/config.guess) \
#      --disable-profile                             \
#      --enable-kernel=2.6.32                        \
#      --enable-obsolete-rpc                         \
#      --with-headers=$TOOLS/include                 \
#      libc_cv_forced_unwind=yes                     \
#      libc_cv_ctors_header=yes                      \
#      libc_cv_c_cleanup=yes
#make
#make install

popd

#echo 'int main(void){}' > dummy.c
#$SYS_TGT-gcc dummy.c -L$TOOLS/lib
#readelf -l a.out

exit 0
