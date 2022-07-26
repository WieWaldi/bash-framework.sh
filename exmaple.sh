#!/usr/bin/env bash
#
# +----------------------------------------------------------------------------+
# | example.sh                                                                 |
# +----------------------------------------------------------------------------+
# | Copyright © 2022 Waldemar Schroeer                                         |
# |                  waldemar.schroeer(at)rz-amper.de                          |
# +----------------------------------------------------------------------------+

# +----- Include bash-framework.sh --------------------------------------------+
export LANG="en_US.UTF-8"
export base_dir="$(dirname "$(readlink -f "$0")")"
export cdir=$(pwd)
export datetime="$(date "+%Y-%m-%d-%H-%M-%S")"
export logfile="${cdir}/${datetime}.log"
export framework_width=80
export notice=notice.txt
export bash_framework="${HOME}/.local/bin/bash-framework.sh"
source ${bash_framework}

# +----- Variables ------------------------------------------------------------+

# +----- Functions ------------------------------------------------------------+

# +----- Main -----------------------------------------------------------------+

display_Notice ${cdir}/${notice}
if [[ "${proceed}" = "no" ]]; then
    exit 1
fi

echo_title "Example Start"

GoAhead="$(antwoord "Shall we conitnue? ${YN}")"
echo -n -e "We shall continue:\r"
if [[ "${GoAhead}" = "yes" ]]; then
    # Do some work
    echo_Done
else
    echo_Skipped
fi

echo_title "Example End"

# +----- End ------------------------------------------------------------------+
echo -e "\n\n"
exit 0
