<script setup lang="ts">
import {ethers} from "ethers";
import { onMounted,ref } from "vue";
import store from "../store";
import {Counter} from "../store";

const getContract = async (): Promise<Counter> => {
  return await store.dict.functions.getCounterContract();
};

const add1 = async () => {
  const contract = await getContract();
  const tx = await contract.countUp();
  console.log('tx : ', tx);
}

const minues1 = async () => {
  const contract = await getContract();
  const tx = await contract.countDown();
  console.log('tx : ', tx);
}

const getCount = async () => {
  const contract = await getContract();
  const count = await contract.getCount();
  console.log(count);
}

onMounted(async () => {
  const contract = await getContract();
  // console.log(contract);
  //on : event정보를 받는건데
  contract.on("CountedTo", (counting: number) => {
    console.log('counting : ',counting);
  });
});
</script>

<template>
    <div>yingshaxo</div>
    <button @click="add1">Count UP(+1</button>
    <button @click="minues1">Count Down(-1</button>
    <button @click="
    async () => {
        await getCount()
    }">Get Count</button>
</template>

<style scoped>

</style>
