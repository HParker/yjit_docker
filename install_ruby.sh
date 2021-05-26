#!/bin/bash

set -ex

git clone --depth 1 https://github.com/Shopify/yjit.git /usr/src/ruby

(
  cd /usr/src/ruby
  autoconf

  mkdir -p /tmp/ruby-build
  pushd /tmp/ruby-build

  gnuArch=$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)
  /usr/src/ruby/configure \
    --build="$gnuArch" \
    --prefix=/usr/local \
    --disable-install-doc \
    --enable-shared \
    ${cppflags:+cppflags="${cppflags}"} \
    ${optflags:+optflags="${debugflags}"} \
    optflags="${optflags:--O3}" \
    ${debugflags:+debugflags="${debugflags}"}

  make -j "$(nproc)"
  make install

  popd
  rm -rf /tmp/ruby-build
)

# rm -fr /usr/src/ruby /root/.gem/

# rough smoke test
(cd && ruby --version && gem --version && bundle --version)
