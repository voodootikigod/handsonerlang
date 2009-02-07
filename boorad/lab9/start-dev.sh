#!/bin/sh
cd `dirname $0`
exec erl -pa $PWD/../ $PWD/ebin $PWD/deps/*/ebin -boot start_sasl -s reloader -s lab9
