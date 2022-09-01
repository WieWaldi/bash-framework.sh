#!/usr/bin/env bash
#
# +----------------------------------------------------------------------------+
# | example.sh                                                                 |
# +----------------------------------------------------------------------------+
# |       Usage: ---                                                           |
# | Description: Example script to show off how bash_framework.sh works        |
# |    Requires: bash_framework.sh                                             |
# |       Notes: ---                                                           |
# |      Author: Waldemar Schroeer                                             |
# |     Company: Rechenzentrum Amper                                           |
# |     Version: 3                                                             |
# |     Created: 10.08.2022                                                    |
# |    Revision: ---                                                           |
# |                                                                            |
# | Copyright © 2022 Waldemar Schroeer                                         |
# |                  waldemar.schroeer(at)rz-amper.de                          |
# +----------------------------------------------------------------------------+

# +----- Include bash-framework.sh --------------------------------------------+
export BASH_FRMWRK_MINVER=3
export LANG="en_US.UTF-8"
export base_dir="$(dirname "$(readlink -f "$0")")"
export cdir=$(pwd)
export datetime="$(date "+%Y-%m-%d-%H-%M-%S")"
export logfile="${cdir}/${datetime}.log"
export framework_width=80

test_file=$(which bash-framework.sh 2>/dev/null)
if [[ $? = 0 ]]; then
    BASH_FRMWK_FILE="${test_file}"
    unset test_file
else
    if [[ -f "${cdir}"/bash-framework.sh ]]; then
        BASH_FRMWK_FILE="${cdir}/bash-framework.sh"
    else
        echo -e "\nNo Bash Framework found. Now I'm sad.-(\n"
        exit 1
    fi
fi

source "${BASH_FRMWK_FILE}"
if [[ "${BASH_FRMWRK_VER}" -lt "${BASH_FRMWRK_MINVER}" ]]; then
    echo -e "\nI've found version ${BASH_FRMWRK_VER} of bash_framework.sh, but I'm in need of version ${BASH_FRMWRK_MINVER}."
    echo -e "You may get the newest version from https://github.com/WieWaldi/bash-framework.sh\n"
    exit 1
fi

# +----- Variables ------------------------------------------------------------+

# +----- Functions ------------------------------------------------------------+

# +----- Main -----------------------------------------------------------------+
# clear
display_Text_File black ${cdir}/notice.txt
if [[ "$(read_Antwoord_YN "Do you want to proceed?")" = "no" ]]; then
    exit 1
fi

echo_Title "Example Start"
echo_Left "Let me start up."
echo_OK
echo_Left "Some Text on the left hand side."
echo_Done
echo_Left "A bit more Text on the left hand side."
echo_Skipped
echo_Left "Some more Text."
echo_Failed

GoAhead="$(read_Antwoord_YN "Shall we conitnue?")"
echo_Left "We shall continue..."
if [[ "${GoAhead}" = "yes" ]]; then
    # Do some work
    echo_Done
else
    echo_Skipped
fi

GoAhead="$(read_Antwoord_YN "Check File Name?")"
if [[ "${GoAhead}" = "yes" ]]; then
    read -p "File Name: " filename
    filenamecode=$(check_File_Name ${filename})
    echo_Left "Result is ${filenamecode}"
    echo_Done

else
    echo_Left "Check File Name..."
    echo_Skipped
fi



echo_Title "Example End"

# +----- End ------------------------------------------------------------------+
echo -e "\n\n"
exit 0
