<template>
  <div class="example">
    <template v-if="wallet">
      <p>Buy me a beer</p>
      <button class="connect-button" @click="onPurchase">Purchase</button>
    </template>
    <template v-else>
      <p class="example-disabled">
        Connect with a wallet to access this example
      </p>
    </template>
  </div>
</template>
<script setup lang="ts">
import { useWallet, useTransfer } from "@connect2ic/vue"

const [wallet] = useWallet()
const [transfer] = useTransfer({
  to: "sxqtl-fc25f-qmea5-27vm2-z2zbf-nokad-hy7c2-yzd62-66zr3-gssxu-uqe",
  amount: Number(0.0001),
})

const onPurchase = async () => {
  await transfer()
}
</script>
