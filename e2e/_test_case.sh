#!/usr/bin/env bash
c_reset=$(echo -en '\033[0m')
c_red=$(echo -en '\033[00;31m')
c_lred=$(echo -en '\033[01;31m')
c_lgreen=$(echo -en '\033[01;33m')

print_suite() {
  echo
  echo "[SUITE]  ${1}"
  echo
}

assert_equal () {
  local actual="${1}"
  local expected="${2}"
  local description="${3:-''}"

  actual="$(echo -e "${actual}" | gsed -e 's/\x1b\[[0-9;]*m//g')"

  if [[ "${actual}" == "${expected}" ]]; then
    echo -en "${c_lgreen}"
    echo -e "[OK]:     ${c_reset}${description}"
  else
    echo -en "${c_lred}"
    echo -e "[FAILED]: ${c_reset}${description}"
    echo
    colordiff  <(echo -e "${actual}" ) <(echo -e "${expected}")

    if [[ "${DEBUG:-false}" == 'true' ]]; then
    echo 'actual:'
    echo -e "${actual}"
    echo
    echo 'expected:'
    echo -e "${expected}"
    fi
    exit 1
  fi
}