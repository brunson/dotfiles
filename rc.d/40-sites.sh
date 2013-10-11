# -*-sh-*-
debug .bash/sites.sh

if [ $( hostname ) = 'ebrunson-lnx' ] ; then

function expand() 
{
    format=$1 ; shift
    
    ret=""
    for char in $* ; do
	ret="$ret $( echo $format | sed -e "s/%/$char/" )"
    done

    echo $ret | tr ' ' ,
}

#Current Batch
#HOSTS="$(seq 169 184)"
#BCURHOSTS=$(expand abait%-lnx $HOSTS)

#Current Batch
HOSTS="$(seq 01 08)"
SCURHOSTS=$(expand abait0%-sd-lnx $HOSTS)

#Boulder Build Hosts
HOSTS="10 $( seq 13 19 ) $( seq 21 24 ) 28 29 30 35 39 $( seq 41 47 ) $( seq 49 57 ) $( seq 60 67 ) $( seq 69 72 ) $( seq 75 84 ) 86 87 89 $( seq 92 97 ) $( seq 100 116 ) $( seq 118 124 ) $( seq 127 134 ) 140 141 142 144 148 $( seq 150 160 )"
BBHOSTS=$(expand abait%-lnx $HOSTS)

#Boulder CI Hosts
HOSTS="$( seq --format='%04g' 101 110 )"
BCHOSTS=$(expand baitci-bd%-lnx $HOSTS)

#Boulder Task Hosts
HOSTS="08 $( seq 23 29 )"
BTHOSTS=$(expand bait-task%-lnx $HOSTS)

#All Boulder Hosts
BHOSTS="$BBHOSTS,$BCHOSTS,$BTHOSTS"

#SD Build Hosts
HOSTS="20 21 $( seq 32 36 ) $( seq 38 42 ) $( seq 44 97 ) $( seq 99 152 ) $( seq 154 168 )"
SBHOSTS=$(expand abait%-sd-lnx $HOSTS)

#SD CI Hosts
HOSTS="$( seq 401 410 )"
SCHOSTS=$(expand abaitci%-sd-lnx $HOSTS)

#All SD Hosts
SHOSTS="$SBHOSTS,$SCHOSTS"

#All Hosts
ALLHOSTS="$BHOSTS,$SHOSTS"

fi

iter() {
    vars=($@)
    for var in ${vars[@]} ; do
	echo ${!var}
    done
}

hosts() {
    iter $@ | tr ',' '\n' 
}

dhosts() {
    iter $@ | sed -e 's/lnx/lnx_droid_host/g'
}

fqhosts() {
    iter $@ | sed -e 's/lnx/lnx.qualcomm.com/g'
}

pack() {
    delim=${1:- }
    tr '\n' "$delim" | sed -e "s/$delim\$/\n/"
}

pfqhosts() {
    fqhosts $@ | pack ,
}

