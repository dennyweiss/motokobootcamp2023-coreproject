#!/usr/bin/env bash
TEST_SPEC="${0}"
TEST_SPEC_DIR=$(dirname "${TEST_SPEC}")
# shellcheck disable=SC1091
source "${TEST_SPEC_DIR}/_test_case.sh"

print_suite "${TEST_SPEC}"

dfx canister call dao submitProposal '("(1) Proin accumsan.","Vivamus mollis risus at dui dictum laoreet", "Pellentesque at iaculis libero.")'
dfx canister call dao submitProposal '("(2) Proin accumsan.","Vivamus mollis risus at dui dictum laoreet", "Pellentesque at iaculis libero.")'
dfx canister call dao submitProposal '("(3) Proin accumsan.","Vivamus mollis risus at dui dictum laoreet", "Pellentesque at iaculis libero.")'
dfx canister call dao submitProposal '("(4) Proin accumsan.","Vivamus mollis risus at dui dictum laoreet", "Pellentesque at iaculis libero.")'
dfx canister call dao submitProposal '("(5) Proin accumsan.","Vivamus mollis risus at dui dictum laoreet", "Pellentesque at iaculis libero.")'

# ( # ////////////////////////////////////////////////////////////////////////////
#   # ++ before +++++++
#   # !! spec   !!!!!!!
#   description="it allows dao -> webpage intercanister call for changing content"
#   actual="$(dfx canister call dao updateWebpageContent '("a")')"
#   expected="()"
#   assert_equal "${actual}" "${expected}" "${description}"    
#   # ++ after  +++++++
# )

