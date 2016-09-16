#!/bin/sh

# we need a wrapper to allow loading of modules from a non-system path, and we can't use PERL5LIB because of taint mode (-T)

GID=`id -g`
UID=`id -u`
OPTS="--user=$UID --group=$GID"
DEFAULT_LIB_ROOT="$HOME/perl5"

# note that this script assumes that we are run in the test directory and that postgrey is in ../postgrey
if [ ! -f ../postgrey ]; then
    echo "ERROR: ../postgrey not found. are you running this script from the test directory?" >&2
    exit 1
fi

[ -d $DBDIR ] || mkdir $DBDIR

if [ -n "$PERL_LOCAL_LIB_ROOT" ]; then
    LIB_ROOT=$PERL_LOCAL_LIB_ROOT
else
    LIB_ROOT=$DEFAULT_LIB_ROOT
fi

exec perl -T -I$LIB_ROOT/lib/perl5 ../postgrey $OPTS "$@"
