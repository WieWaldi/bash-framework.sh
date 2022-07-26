#!/usr/bin/env bash
#
# +----------------------------------------------------------------------------+
# | bash-framework.sh                                                          |
# +----------------------------------------------------------------------------+
# |       Usage: Has to be included/sourced from other scripts                 |
# | Description: Bash Framework to simplify scripting                          |
# |    Requires: GNU core utils                                                |
# |       Notes: ---                                                           |
# |      Author: Waldemar Schroeer                                             |
# |     Company: Rechenzentrum Amper                                           |
# |     Version: 3                                                             |
# |     Created: 10.08.2022                                                    |
# |    Revision: ---                                                           |
# |                                                                            |
# | Copyright © 2019 Waldemar Schroeer                                         |
# |                  waldemar.schroeer(at)rz-amper.de                          |
# |                                                                            |
# +----- List of Functions ----------------------------------------------------+
# | echo_Equals     read_Antwoord_YN        get_User                           |
# | echo_Left       read_Antwoord_Secretly  get_OperatingSystem                |
# | echo_Right      display_Text_File       get_Distribution                   |
# | echo_Title                                                                 |
# | echo_OK                                                                    |
# | echo_Done                                                                  |
# | echo_NotNeeded                                                             |
# | echo_Skipped                                                               |
# | echo_Failed                                                                |
# | echo_Error_Msg                                                             |
# | echo_Box                                                                   |
# |                                                                            |
# +----- Colors ---------------------------------------------------------------+
# | Color         #define             Value       RGB                          |
# | black         COLOR_BLACK         0           0, 0, 0                      |
# | red           COLOR_RED           1           max,0,0                      |
# | green         COLOR_GREEN         2           0,max,0                      |
# | yellow        COLOR_YELLOW        3           max,max,0                    |
# | blue          COLOR_BLUE          4           0,0,max                      |
# | magenta       COLOR_MAGENTA       5           max,0,max                    |
# | cyan          COLOR_CYAN          6           0,max,max                    |
# | white         COLOR_WHITE         7           max,max,max                  |
# |                                                                            |
# +----------------------------------------------------------------------------+

# +----- Variables ------------------------------------------------------------+
BASH_FRMWRK_VER=3
RED=$(tput setaf 1)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
YN="(Yes|${BRIGHT}No${NORMAL}) >> "

# +----- Functions ------------------------------------------------------------+
__exit_Error() {                      # Just output an error condition and exit
    local exitcode=2
    local errormsg="Unknown Error"
    local re='^[0-9]+$'
    if [[ -n ${1} ]]; then
        if [[ ${1} =~ ${re} ]]; then
            exitcode=${1}
            if [[ -n ${2} ]]; then
                errormsg=${2}
            fi
        else
            if ! [[ ${1} =~ ${re} ]]; then
                errormsg=${1}
            fi
        fi
    fi
    echo >&2 "${scriptname}:" "${errormsg}"
    exit "${exitcode}"
}

__exit_Usage() {                      # Output an error and print synopsis line
    local exitcode=2
    local errormsg="Unknown Error"
    local re='^[0-9]+$'
    if [[ -n ${1} ]]; then
        if [[ ${1} =~ ${re} ]]; then
            exitcode=${1}
            if [[ -n ${2} ]]; then
                errormsg=${2}
            fi
        else
            if ! [[ ${1} =~ ${re} ]]; then
                errormsg=${1}
            fi
        fi
    fi
    echo -e >&2 "\n${scriptname}:" "${errormsg}"
    sed >&2 -n '1,26d; /^###/q; /^#/!q; /^#$/q; s/^#  */Usage: /p;' ${cdir}/${scriptname}
    echo -e >&2 "For help use ${scriptname} --help"
    exit "${exitcode}"
}

__exit_Help() {                       # Output full header comments
    local exitcode=10
    sed >&2 -n '1,25d; /^###/q; /^#/!q; s/^#*//; s/^ //; p' ${cdir}/${scriptname}
    exit "${exitcode}"
}

__echo_Equals() {
    counter=0
    while [  $counter -lt "$1" ]; do
    printf '='
    (( counter=counter+1 ))
    done
}

__echo_Title() {
    title=$1
    ncols=$(tput cols)
    nequals=$(((framework_width-${#title})/2-1))
    tput setaf 4 0 0
    __echo_Equals "$nequals"
    tput setaf 6 0 0
    printf " %s " "$title"
    tput setaf 4 0 0
    __echo_Equals "$nequals"
    tput sgr0
    echo
}

__echo_Left() {
    text=${1}
    echo -n -e "${1}\r"
}
__echo_Right() {
    text=${1}
    echo
    tput cuu1
    tput cuf "$((${framework_width} - 1))"
    tput cub ${#text}
    echo "${text}"
}

__echo_OK() {
    tput setaf 2 0 0
    __echo_Right "[ OK ]"
    tput sgr0
}

__echo_Done() {
    tput setaf 2 0 0
    __echo_Right "[ Done ]"
    tput sgr0
}

__echo_NotNeeded() {
    tput setaf 3 0 0
    __echo_Right "[ Not Needed ]"
    tput sgr0
}

__echo_Skipped() {
    tput setaf 3 0 0
    __echo_Right "[ Skipped ]"
    tput sgr0
}

__echo_Failed() {
    tput setaf 1 0 0
    __echo_Right "[ Failed ]"
    tput sgr0
}

__echo_Error_Msg() {
    echo -n -e "\n${RED} [ Error ]${NORMAL} ${1}\n\n"
}

# Option
#  1         Style of box:
#            ASCII: blank, banner, curses, ascii, lines,
#            UTF-8: box, round, bold, double, shadow, shadow_dbl, thick
#  2         Indent output on left side this many characters
#  3         Box width minimum, expands if text is wider
#  4         Remove any initial common indent in input (true|false)
#  5         Center the block of text inside the box (true|false)
#            Requires Option 3 set not zero
#  6         Multine Text

__echo_Box() {
    box_style="${1}"
    box_indent="${2}"
    box_width=${3}
    remove_indent=${4}
    center=${5}
    text_input=${6}
    
    if [[ "${center}" = "true" ]]; then
        remove="true"
    fi

    echo "${6}"
    
    case "$box_style" in
        blank)      ctl=" " et=" " ctr=" " el=" " er=" " cbl=" " eb=" " cbr=" " ;;
        # ASCII
        banner)     ctl="#" et="#" ctr="#" el="#" er="#" cbl="#" eb="#" cbr="#" ;;
        curses)     ctl="+" et="-" ctr="+" el="|" er="|" cbl="+" eb="-" cbr="+" ;;
        ascii)      ctl="." et="-" ctr="." el="|" er="|" cbl="'" eb="-" cbr="'" ;;
        lines)      ctl="-" et="-" ctr="-" el=" " er=" " cbl="-" eb="-" cbr="-" ;;
        # Unicode
        box)        ctl="┌" et="─" ctr="┐" el="│" er="│" cbl="└" eb="─" cbr="┘" ;;
        round)      ctl="╭" et="─" ctr="╮" el="│" er="│" cbl="╰" eb="─" cbr="╯" ;;
        bold)       ctl="┏" et="━" ctr="┓" el="┃" er="┃" cbl="┗" eb="━" cbr="┛" ;;
        double)     ctl="╔" et="═" ctr="╗" el="║" er="║" cbl="╚" eb="═" cbr="╝" ;;
        shadow)     ctl="┌" et="─" ctr="┒" el="│" er="┃" cbl="┕" eb="━" cbr="┛" ;;
        shadow_dbl) ctl="┌" et="─" ctr="╖" el="│" er="║" cbl="╘" eb="═" cbr="╝" ;;
        thick)      ctl="▛" et="▀" ctr="▜" el="▌" er="▐" cbl="▙" eb="▄" cbr="▟" ;;
        # Error
        *) Error "Unknown Box Style given" ;;
    esac

    text_length=0
    text_indent=999
    while IFS= read -r line; do
        text+=( "$line" )                                 # save the line
        (( ${#line} )) || continue                        # ignore blank lines
        ((text_length<${#line})) && text_length=${#line}  # get max length
        line=${line%%[^ ]*}                               # remove non-indent
        ((text_indent>${#line})) && text_indent=${#line}  # get overall indent
    done < <(echo ${6})

    (( ${#text[@]} > 0 )) || Error "No text input!"
    (( text_indent==999 )) && text_indent=0    # only blank lines - fix indent!
    
    if [[ "${remove_indent}" = "true" ]]; then                     # remove original text indent?
        text_length=$((text_length-text_indent)) # adjust text length
    else
        text_indent=0                            # don't remove any indent (leave it)
    fi

    if (( box_width < text_length+4 )); then
        box_width=$((text_length+4))
    fi

    if [[ $center ]]; then        # block center the text as a whole
        # calculate amount of the original text indent to remove
        text_indent=$((text_indent-(box_width-4-text_length)/2))
        # if indent is negative, then we need to add more indent
        if (( text_indent < 0 )); then
            printf -v add_indent "%*s" $text_indent;
            text_indent=0
        fi
    else
        add_indent=''                # not adding any extra indent
    fi

    ((box_indent<0)) && box_indent=$(( (COLUMNS-box_width)/2 ))

    printf -v line "%*s" $((box_width-2))
    printf "%*s%s%s%s\n" $box_indent '' "$ctl" "${line//?/$et}" "$ctr"

    for line in "${text[@]}"; do
        line="${add_indent}${line}"    # add more indent to the line (if needed)
        line="${line:text_indent}"     # remove the appropriate amount of indent
     
        # Works except feild size is calculated in characters (postix requirment)
        # and thus will com out wrong for UTF-8 chars
        #printf "%*s%s %*s %s\n" $box_indent '' "$el" $((4-box_width)) "$line" "$er"
     
        # This works with UTF-8 but by doing calculation in chars ourselves
        printf "%*s%s %s%*s %s\n" $box_indent '' "$el" "$line" \
                       $((box_width-4-${#line})) '' "$er"
    done

    printf -v line "%*s" $((box_width-2))
    printf "%*s%s%s%s\n" $box_indent '' "$cbl" "${line//?/$eb}" "$cbr"
}

__read_Antwoord_YN() {
    read -p "${1} ${YN}" antwoord
        if [[ ${antwoord} == [yY] || ${antwoord} == [yY][Ee][Ss] ]]; then
            echo "yes"
        else
            echo "no"
        fi
}

__read_Antwoord_Secretly() {
    unset secret
    secret=
    unset charcount
    charcount=0
    prompt="${1}"
    while IFS= read -p "${prompt}" -r -s -n 1 char
    do
        if [[ $char == $'\0' ]]; then
            break
        fi
        if [[ $char == $'\177' ]] ; then
            if [ $charcount -gt 0 ] ; then
                charcount=$((charcount-1))
                prompt=$'\b \b'
                secret="${secret%?}"
            else
                prompt=''
            fi
        else
            charcount=$((charcount+1))
            prompt='*'
            secret+="${char}"
        fi
    done
    echo "${secret}"
}

__display_Text_File() {
    case ${1} in
        Black|black)
            tput setaf 0 0 0
            ;;
        Red|red)
            tput setaf 1 0 0
            ;;
        Green|green)
            tput setaf 2 0 0
            ;;
        Yellow|yellow)
            tput setaf 3 0 0
            ;;
        Blue|blue)
            tput setaf 4 0 0
            ;;
        Magenta|magenta)
            tput setaf 5 0 0
            ;;
        Cyan|cyan)
            tput setaf 6 0 0
            ;;
        White|white)
            tput setaf 7 0 0
            ;;
    esac
    cat ${2}
    tput sgr0
}

__display_Notice() {
    tput setaf 6
    cat ${BASE_DIR}/$1
    tput sgr0
    proceed="$(read_Antwoord "Do you want to proceed? ${YN}")"
}

__clear_Logfile() {
    if [[ -f ${logfile} ]]; then
        rm ${logfile}
    fi
}

__check_File_Name() {
    if [[ -d S{1} ]]; then
        if [[ -w ${1} ]]; then
            echo "1"
        else
            echo "4"
        fi
    elif [[ -L ${1} ]]; then
        if [[ -d "$(readlink ${1})" ]]; then
            echo "2"
        else
            echo "5"
        fi
    elif [[ -f ${1} ]]; then
        echo "6"
    else
        if /bin/mkdir -p ${1} &>/dev/null; then
            echo "3"
        else
            echo "7"
        fi
    fi
}

__get_User() {
    if ! [[ $(id -u) = 0 ]]; then
        echo_Error_Msg "This script must be run as root."
        exit 1
    fi
}

__get_OperatingSystem() {
    os=$(uname -s)
    kernel=$(uname -r)
    architecture=$(uname -m)
}

__get_Distribution() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        distribution=$NAME
        version=$VERSION_ID
        case ${ID} in
            rhel|centos)
                packagelistext="${ID}.${VERSION_ID::1}"
                ;;
            fedora)
                packagelistext="${ID}.${VERSION_ID}"
                ;;
        esac
        echo -e "\nSeems to be:"
        echo -e "  ${distribution} ${version} ${kernel} ${architecture}\n" 
    else
        echo_Error_Msg "I need /etc/os-release to figure what distribution this is."
        exit 1    
    fi
}

# +----- EOF ------------------------------------------------------------------+
