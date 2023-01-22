# Checks

1. Get content : denied

    ```shell
    # be on local env
    dfx identity use mbc2023_controller
    $(dfx canister call dao getContent) == $(dfx canister call webpage getContent)
    ```