#!/bin/bash
#  Copyright (C) 2018-2020 LEIDOS.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); you may not
#  use this file except in compliance with the License. You may obtain a copy of
#  the License at
# 
#  http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#  License for the specific language governing permissions and limitations under
#  the License.

# script to run tests, generate test-coverage, and store coverage reports in a place
# easily accessible to sonar. Test names should follow convention run<pluginName>Tests
mkdir coverage
cd coverage 
find $GITHUB_WORKSPACE -iname "*\.gcda" -o -iname "\.gcna" | xargs gcov
#gcovr --sonarqube /__w/jpo-cvdp/jpo-cvdp/coverage/coverage.xml -s -f /__w/jpo-cvdp/jpo-cvdp/coverage/ -r .
gcovr --sonarqube /__w/jpo-cvdp/jpo-cvdp/cv-lib/src/*.cpp -s -f /__w/jpo-cvdp/jpo-cvdp/build/cv-lib/src/ -r .
gcovr --sonarqube /__w/jpo-cvdp/jpo-cvdp/src/*.cpp -s -f /__w/jpo-cvdp/jpo-cvdp/build/src/ -r .
gcovr --sonarqube /__w/jpo-cvdp/jpo-cvdp/kafka-test/src/*.cpp -s -f /__w/jpo-cvdp/jpo-cvdp/build/kafka-test/src/ -r .

