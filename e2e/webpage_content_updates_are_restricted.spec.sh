#!/usr/bin/env bash
TEST_SPEC="${0}"
TEST_SPEC_DIR=$(dirname "${TEST_SPEC}")
# shellcheck disable=SC1091
source "${TEST_SPEC_DIR}/_test_case.sh"

print_suite "${TEST_SPEC}"

( # ////////////////////////////////////////////////////////////////////////////
  description="webpage and dao deliver the same content"
  # ++ before +++++++
  # !! spec   !!!!!!!
  actual="$(dfx canister call dao getContent)"
  expected="$(dfx canister call webpage getContent)"
  assert_equal "${actual}" "${expected}" "${description}"    
  # ++ after  +++++++
)

( # ////////////////////////////////////////////////////////////////////////////
  # ++ before +++++++
  # !! spec   !!!!!!!
  description="it permitts changing content by local principal"
  actual="$(dfxcanister call webpage updateWebpageContent '("asasas")' 2>/dev/null; echo $?;)"
  expected="127"
  assert_equal "${actual}" "${expected}" "${description}"    
  # ++ after  +++++++
)

( # ////////////////////////////////////////////////////////////////////////////
  # ++ before +++++++
  # !! spec   !!!!!!!
  description="it allows dao -> webpage intercanister call for changing content"
  actual="$(dfx canister call dao updateWebpageContent '("a")')"
  expected="()"
  assert_equal "${actual}" "${expected}" "${description}"    
  # ++ after  +++++++
)

