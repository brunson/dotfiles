# -*-sh-*-
debug .bash/sites.sh

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
HOSTS="41 46 49 53 55 60 63 75 80 81 116 119 123 132 133"
CURHOSTS=$(expand abait%-lnx $HOSTS)

#Boulder Build Hosts
HOSTS="10 $( seq 13 19 ) 21 28 35 39 42 54 71 $( seq 100 110 ) 150 $( seq 152 160 )"
BBHOSTS=$(expand abait%-lnx $HOSTS)

#Boulder CI Hosts
HOSTS="$( seq --format='%02g' 2 10 )"
BCHOSTS=$(expand bdbaitci001-%-lnx $HOSTS)

#Boulder Task Hosts
HOSTS="08 $( seq 23 29 )"
BTHOSTS=$(expand bait-task%-lnx $HOSTS)

#All Boulder Hosts
BHOSTS="$BBHOSTS,$BCHOSTS,$BTHOSTS"

#SD Build Hosts
HOSTS="21 32 33 34 38 39 $( seq 40 42 ) 44 $( seq 46 55 ) $( seq 57 62 ) 64 $( seq 69 72 ) 74 75 $( seq 77 80 ) $( seq 82 89 ) 91 92 93 97 100 101 105 109 110 112 114 115 116 118 119 $( seq 120 129 ) $( seq 130 147 ) $( seq 149 152 ) $( seq 154 157 ) 159 160 163 167 168"
SBHOSTS=$(expand abait%-sd-lnx $HOSTS)

#SD CI Hosts
HOSTS="$( seq 401 410 )"
SCHOSTS=$(expand abaitci%-sd-lnx $HOSTS)

#All SD Hosts
SHOSTS="$SBHOSTS,$SCHOSTS"

#All Hosts
ALLHOSTS="$BHOSTS,$SHOSTS"

hosts() {
    echo $@ | tr ',' '\n' 
}

dhosts() {
    hosts $@ | sed -e 's/lnx/lnx_droid_host/'
}

fqhosts() {
    hosts $@ | sed -e 's/lnx/lnx.qualcomm.com/'
}

pack() {
    tr '\n' ',' | sed 's/,$/\n/'
}

pfqhosts() {
    fqhosts $@ | pack
}

