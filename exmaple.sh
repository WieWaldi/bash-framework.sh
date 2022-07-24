#!/usr/bin/env bash
#
# +----------------------------------------------------------------------------+
# | example.sh                                                                 |
# +----------------------------------------------------------------------------+
# | Copyright © 2022 Waldemar Schroeer                                         |
# |                  waldemar.schroeer(at)rz-amper.de                          |
# +----------------------------------------------------------------------------+

export LANG="en_US.UTF-8"
export datetime="$(date "+%Y-%m-%d-%H-%M-%S")"
export logfile="/tmp/suckless.X11_prepare_${datetime}.log"
export framework_width=80
export BASE_DIR="$(dirname "$(readlink -f "$0")")"
export notice=notice.txt
export cdir=$(pwd)
source "$BASE_DIR/bash-framework.sh"

# +----- Variables ------------------------------------------------------------+

# +----- Functions ------------------------------------------------------------+

# +----- Main -----------------------------------------------------------------+

display_Notice ${notice}
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
