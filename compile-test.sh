#!/bin/sh

before() {
  rm -rf build cache
  cp -r test build
  mkdir cache
}

compile() {
  pushd .
  source bin/compile build cache 2>&1
  popd
}

it_installs_go() {
  unset GOROOT
  compile
  test -f $GOROOT/bin/go
  test -x $GOROOT/bin/go
  rm -rf build cache
}

it_skips_go_compile_if_exists() {
  mkdir -p cache/go1.1/go
  compile | grep Using
  rm -rf build cache
}

it_compiles_app() {
  compile
  test -f build/bin/mytest
  test -x build/bin/mytest
  test "$(./build/bin/mytest 2>&1)" = "ok"
  rm -rf build cache
}
