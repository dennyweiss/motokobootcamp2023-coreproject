#!/usr/bin/env bash
TEST_SPEC="${0}"
TEST_SPEC_DIR=$(dirname "${TEST_SPEC}")
# shellcheck disable=SC1091
source "${TEST_SPEC_DIR}/_test_case.sh"

ANNONYMOUS_PRINCIPAL=anonymous
ADMIN_PRINCIPAL=mbc2023_controller

print_suite "${TEST_SPEC}"

( # ////////////////////////////////////////////////////////////////////////////
  description="{dao} has initial environment"
  # ++ before +++++++
  # !! spec   !!!!!!!
  actual="$(dfx canister call dao getEnvironment)"
  expected="(variant { local })"
  assert_equal "${actual}" "${expected}" "${description}"    
  # ++ after  +++++++
)

( # ////////////////////////////////////////////////////////////////////////////
  description="{webpage} has initial environment"
  # ++ before +++++++
  # !! spec   !!!!!!!
  actual="$(dfx canister call dao getEnvironment)"
  expected="(variant { local })"
  assert_equal "${actual}" "${expected}" "${description}"    
  # ++ after  +++++++
)

( # ////////////////////////////////////////////////////////////////////////////
  description="{dao} annonymous principal cannot change environment"
  # ++ before +++++++
  # !! spec   !!!!!!!
  dfx identity use "${ANNONYMOUS_PRINCIPAL}" &>/dev/null
  actual="$(dfx canister call dao setEnvironment '(variant { ic })' &>/dev/null; echo $?;)"
  expected="255"
  assert_equal "${actual}" "${expected}" "${description}"    
  # ++ after  +++++++
  dfx identity use "${ADMIN_PRINCIPAL}" &>/dev/null
)

( # ////////////////////////////////////////////////////////////////////////////
  description="{webpage} annonymous principal cannot change environment"
  # ++ before +++++++
  # !! spec   !!!!!!!
  dfx identity use "${ANNONYMOUS_PRINCIPAL}" &>/dev/null
  actual="$(dfx canister call webpage setEnvironment '(variant { ic })' &>/dev/null; echo $?;)"
  expected="255"
  assert_equal "${actual}" "${expected}" "${description}"    
  # ++ after  +++++++
  dfx identity use "${ADMIN_PRINCIPAL}" &>/dev/null
)

( # ////////////////////////////////////////////////////////////////////////////
  description="{dao} admin define change environment"
  # ++ before +++++++
  # !! spec   !!!!!!!
  actual="$(cat <<HERE
$(dfx canister call dao setEnvironment '(variant { ic })' &>/dev/null)
$(dfx canister call dao getEnvironment)
HERE
)"
  expected="$(cat <<'HERE'

(variant { ic })
HERE
)"
  assert_equal "${actual}" "${expected}" "${description}"    
  # ++ after  +++++++
  dfx canister call dao setEnvironment '(variant { local })' &>/dev/null
)

( # ////////////////////////////////////////////////////////////////////////////
  description="{webpage} admin define change environment"
  # ++ before +++++++
  # !! spec   !!!!!!!
  actual="$(cat <<HERE
$(dfx canister call webpage setEnvironment '(variant { ic })' &>/dev/null)
$(dfx canister call webpage getEnvironment)
HERE
)"
  expected="$(cat <<'HERE'

(variant { ic })
HERE
)"
  assert_equal "${actual}" "${expected}" "${description}"    
  # ++ after  +++++++
  dfx canister call webpage setEnvironment '(variant { local })' &>/dev/null
)
