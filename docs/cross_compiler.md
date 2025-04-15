# Cross Compiler

I should be using a cross compiler because my local system compiler is configured for the operating system it's running on. Unless I am developing on my own OS.


## How to install?

0. Preperations

```sh
export PREFIX="$HOME/opt/cross"
export TARGET=x86_64-elf
export PATH="$PREFIX/bin:$PATH
```

1. Create the directories

```sh
mkdir -p $HOME/src
cd $HOME/src
mkdir build-binutils build-gcc
```

2. Dowwnload sources

```sh
wget https://ftp.gnu.org/gnu/binutils/binutils-2.44.tar.xz
wget https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz
wget https://ftp.gnu.org/gnu/gdb/gdb-16.2.tar.xz
```

3. Extract

```sh
tar -xf binutils-2.44.tar.xz
tar -xf gcc-14.2.0.tar.xz
tar -xf gdb-16.2.tar.xz
```

4. Build Binutils

```sh
cd build-binutils
../binutils-2.44/configure --target=$TARGET --prefix=$PREFIX --with-sysroot --disable-nls --disable-werror
make -j$(nproc)
make install
```

5. Build GCC

Since we're building a cross compiler for x86-64, it's ideal to build libgcc without the "red zone." Read the following article: [Libgcc without red zone](https://wiki.osdev.org/Libgcc_without_red_zone).

```sh
cd ../gcc-14.2.0
./contrib/download_prerequisites

cd ../build-gcc
../gcc-14.2.0/configure --target=$TARGET --prefix=$PREFIX --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc -j$(nproc)
make all-target-libgcc -j$(nproc)
make install-gcc
make install-target-libgcc
```


6. Build GDB

```sh
../gdb.16.2/configure --target=$TARGET --prefix="$PREFIX" --disable-werror
make all-gdb
make install-gdb
```

- [Why do I need a Cross Compiler?](https://wiki.osdev.org/Why_do_I_need_a_Cross_Compiler%3F#:~:text=Some%20compilers%20don't%20even,you%20will%20run%20into%20trouble.)
- [Cross Compiler](https://wiki.osdev.org/GCC_Cross-Compiler)

