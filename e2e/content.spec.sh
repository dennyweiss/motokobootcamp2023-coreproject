#!/usr/bin/env bash
TEST_SPEC="${0}"
TEST_SPEC_DIR=$(dirname "${TEST_SPEC}")
# shellcheck disable=SC1091
source "${TEST_SPEC_DIR}/_testCase.sh"

print_suite "${TEST_SPEC}"

(
  description="webpage and dao deliver the same content"
  actual="$(dfx canister call dao getContent)"
  expected="$(dfx canister call webpage getContent)"
  assert_equal "${actual}" "${expected}" "${description}"    
)
