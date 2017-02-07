#!/bin/bash -eu
#
# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

./autogen.sh --without-cython --enable-debug
make -j$(nproc) clean
make -j$(nproc) all

for fuzzer in bplist_fuzzer xplist_fuzzer; do
  $CXX $CXXFLAGS -std=c++11 -Iinclude/ \
      $SRC/$fuzzer.cc -o $OUT/$fuzzer \
      -lFuzzingEngine src/.libs/libplist.a
done

zip -j $OUT/bplist_fuzzer_seed_corpus.zip $SRC/libplist/test/data/*.bplist
zip -j $OUT/xplist_fuzzer_seed_corpus.zip $SRC/libplist/test/data/*.plist

cp $SRC/*.dict $SRC/*.options $OUT/