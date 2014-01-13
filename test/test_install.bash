#!/bin/bash

fail() {
  echo "$*" >&2
  exit 1
}

install () {
  public/install "$@"
}

test-arguments () {
  local PATH=$PATH:$PWD/target/darwin/amd64
  install -o darwin -a amd64 "$PWD/target/darwin/amd64" ||
    fail "failed to install with arguments"
  local DESC="$(file -b target/darwin/amd64/exercism)"
  test "$DESC" == "Mach-O 64-bit executable x86_64" ||
    fail "failed with arguments, got: $DESC"
}

test-environment () {
  local PATH=$PATH:$PWD/target/linux/386
  DIR="$PWD/target/linux/386" OS=linux ARCH=386 install ||
    fail "failed to install with environment"
  local DESC="$(file -b target/linux/386/exercism)"
  test "$DESC" == "ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), statically linked, not stripped" ||
    fail "failed with arguments, got: $DESC"
}

(test-arguments)
(test-environment)
true
