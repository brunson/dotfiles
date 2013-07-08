#!/usr/bin/env bash
debug .bash/bait_scm_bashrc.sh

#ectool needs to be in PATH for SCM scripts to work
export PATH=$PATH:/opt/electriccloud/electriccommander/bin

#BAIT_SCM environment variables

#VAR                         Default Value                  Description
#===                         =============                  ===========
#WS                          none - required                Users workspace directory
#BAIT_SCM_COMMANDER_SERVER   commander-dev.qualcomm.com     Default commander server
#                                                           for import/export projects
#BAIT_SCM_SCRIPT_REL_PATH    ./tools/scm                    Relative path from an SCM
#                                                           tree to dir holding
#                                                           import/export/delete prj scripts
#BAIT_SCM_CONF_FILE          $BAIT_SCM_SCRIPT_REL_PATH/     XML config file SCM scripts
#                            config/bait_scm_config.xml     use to know project location
#                                                           in tree
#                                                           Relative path from tree root
#BAIT_SCM_TREES              $WS/bait_scm                   Directory where scm trees for each
#                                                           branch can be found
#                                                           (dev dev_test stable stable_test)
#BAIT_SCM_GIT_URL          git://git-android.quicinc.com  server to use for 'repo init'

[ ! -z "$BAIT_SCM_COMMANDER_SERVER" ] || export BAIT_SCM_COMMANDER_SERVER='commander-dev.qualcomm.com'
[ ! -z "$BAIT_SCM_SCRIPT_REL_PATH" ] || export BAIT_SCM_SCRIPT_REL_PATH='./tools/scm'
[ ! -z "$BAIT_SCM_CONF_FILE" ] ||
    export BAIT_SCM_CONF_FILE="$BAIT_SCM_SCRIPT_REL_PATH/config/bait_scm_config.xml"

[ ! -z "$BAIT_SCM_GIT_URL" ] || export BAIT_SCM_GIT_URL="git://git-android.quicinc.com"

__git_ps1() 
{
 :
}

if [ ! -d "$WS" ] && [ ! -d "$BAIT_SCM_TREES" ]; then
    msg=$(cat <<END_MSG
Neither WS nor BAIT_SCM_TREES points to a directory. bscm_repo_setup not available.
\n
END_MSG
         )
    #printf "$msg" >&2
    #Don't exit login shell
    #exit 1
else
    [ ! -z "$BAIT_SCM_TREES" ] || export BAIT_SCM_TREES="$WS/bait_scm"

    bscm_repo_setup() {
        trace=$(
            set -o nounset
            set -o errexit

            if [ $# -eq 0 ]; then
                bscm_repo_setup dev dev_test master stable_test
                exit $?
            fi

        #Bash 4.0 convert to lowercase
        #lower_args=${@,,}
            local lc_branches=$(echo "$@" | tr '[:upper:]' '[:lower:]')

            for branch in $lc_branches; do
                if ! [[ "$branch" =~ dev|dev_test|master|stable|stable_test ]]; then
                    printf "$branch is not a supported branch.\n" >&2; exit 1
                fi
            done

            for branch in $lc_branches; do

                set -o xtrace
                mkdir -p "$BAIT_SCM_TREES/$branch"
                cd "$BAIT_SCM_TREES/$branch"
                repo init -u "$BAIT_SCM_GIT_URL/automation/manifest" -b "$branch"
                repo sync
                set +o xtrace
            done
        )

        ret_val=$?
        printf "$trace\n"
        return $ret_val
    }
fi

bscm_ectool_install() {

    [ ! -z "$PLC" ] || local PLC='/prj/lnxbuild/commander'

    local ec_dir='/opt/electriccloud/electriccommander'
    local bkup_date=$(date "+%y-%m-%d-%H:%M:%S")
    local bkup_dir=

    if ! [ -d "$PLC" ]; then
        printf "PLC=$PLC does not point to a directory\n" >&2
        return 1
    fi

    if [ -e /etc/init.d/commanderAgent ]; then
         printf "Detected existing Commander Agent Install... Aborting\n"
         printf "bscm_ectool_install will only update 'tools only' installation\n"
         return 1
    fi

    mach_type=$(uname | sed -e 's/Darwin/mac/' -e 's/Linux/linux/')

    if ! [ "$mach_type" = 'linux' -o "$mach_type" = 'mac' ]; then
        printf "Unsupported machine type: $mach_type\n" >&2
        return 1
    fi

    installer=$($(which ls) "$PLC/latest/$mach_type/x86/" |
               grep -i --only-matching  --perl-regexp \
               "\b.*commander.*\.bin\b|\bElectricCommander-[0-9]+.*[0-9]\b")
    installer_fq="$PLC/latest/$mach_type/x86/$installer"

    if [ -z "$installer_fq" ] || ! [ -f "$installer_fq" -a -x "$installer_fq" ]; then
        printf "Can't find or can't execute installer: $installer_fq\n" >&2
        return 1
    fi

    if [ -d $ec_dir ]; then
       bkup_dir=$ec_dir.bait_scm_bak.$bkup_date
       set -o xtrace
       sudo mv $ec_dir $bkup_dir
       set +o xtrace
       if [ $? -ne 0 ]; then
           printf "Backup failed!\n" >&2
           return 1
       fi
    fi

    local install_success='no'

    case $mach_type in
        linux)
            set -o xtrace
            sudo $installer_fq --mode silent
            [ $? -eq 0 ] && install_success='yes'
            set +o xtrace

            ;;

        mac)
            set -o xtrace
            local tmp_dir=$(mktemp -d -t bscm_ec_install)
            cp "$installer_fq" "$tmp_dir/$installer"

            echo "EC_INSTALL_TYPE=tools" >> $tmp_dir/install_cfg
            echo "DESINTATION_DIR=/opt" >> $tmp_dir/install_cfg
            echo "AGENT_USER_TO_RUN_AS=$USER" >> $tmp_dir/install_cfg
            echo "AGENT_GROUP_TO_RUN_AS=_developer" >> $tmp_dir/install_cfg

            sudo "$tmp_dir/$installer" --config "$tmp_dir/install_cfg"
            [ $? -eq 0 ] && install_success='yes'
            set +o xtrace

            sudo rm -rf $tmp_dir

            ;;
    esac

    if ! [ $install_success == 'yes' ]; then
        printf "Install failed!\n" >&2
        if [ -d "bkup_dir" ]; then
            set -o xtrace
            sudo cp -f $bkup_dir $ec_dir
            set +o xtrace
        fi
        return 1
    fi

}

#Install ec perl modules in local perl
bscm_ecperl_install() {

    local ec_dir='/opt/electriccloud/electriccommander'
    local ec_tar=$(echo $ec_dir/src/ElectricCommander-*.tar.gz)

    if [ -z "$ec_tar" ] || ! [ -f "$ec_tar" ] || ! [ -r "$ec_tar" ]; then
        printf "Problem reading archive: \`$ec_tar'\n"
        return 1
    fi

    local tmp_dir=$(mktemp -d -t bscm_ecperl_install.XXXX)

    trace=$(
        set -o nounset
        set -o errexit
        set -o xtrace

        cd $tmp_dir
        tar -xzf $ec_tar
        cd ElectricCommander-*
        perl Makefile.PL
        sudo make install
    )

    local result=$?
    printf "$trace\n"
    if [ $result -ne 0 ]; then
        printf "Failed perl install!\n"
        return 1
    fi

    set -o xtrace
    sudo rm -rf $tmp_dir
    set +o xtrace

}

_bscm_op_impl() {

    local op=$1; shift
    local msg=

    found_script='no'
    [ -f "$BAIT_SCM_SCRIPT_REL_PATH/ec_${op}_projects.sh" ] && found_script='yes'

    for arg in $@; do
        if echo "$arg" | grep --silent '^--help$|^-h$'; then
            msg=$(cat <<END_MSG
bscm_${op} is an alias function for ec_${op}_projects.sh
It must be run from the root of a scm tree.
\n
END_MSG
                 )
            printf "$msg"
            [ "$found_script" == 'yes' ] &&
                "$BAIT_SCM_SCRIPT_REL_PATH/ec_${op}_projects.sh" --help
            return 0
        fi
    done

    if [ "$found_script" == 'yes' ]; then
        "$BAIT_SCM_SCRIPT_REL_PATH/ec_${op}_projects.sh" $@
    else
        msg=$(cat <<END_MSG
bscm_${op} could not find $BAIT_SCM_SCRIPT_REL_PATH/ec_${op}_projects.sh
This alias function only works when called from the root of a scm tree
\n
END_MSG
             )
        printf "$msg" >&2; return 1
    fi
}

bscm_export() {
    _bscm_op_impl 'export' -v $@
}

bscm_import() {
    _bscm_op_impl 'import' -v $@
}

bscm_delete() {
    _bscm_op_impl 'delete' -v $@
}
