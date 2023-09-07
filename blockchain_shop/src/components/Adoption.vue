<script setup lang="ts">
import { onMounted, reactive } from "vue";
import store from "../store";
import { hexStringColorToRgba } from "../utils";

const dict = reactive({
  data: {
    adopterAddressList: [] as string[],
  },
  functions: {
    updateAdopterAddressList: async () => {
      const contract = await store.dict.functions.getAdoptionContract();
      // const adopterAddressList = await contract.getAdopterAddressList();
      let adoptersList = await contract.getAdopters();
      dict.data.adopterAddressList = adoptersList;
      // dict.data.adopterAddressList = adopterAddressList;
    },
    getBackgroundColorByIndex: (index: number) => {
      const colors = ['#f44336', '#e91e63', '#9c27b0', '#673ab7', '#3f51b5', '#2196f3', '#03a9f4', '#00bcd4', '#009688', '#4caf50', '#8bc34a', '#cddc39', '#ffeb3b', '#ffc107', '#ff9800', '#ff5722', '#795548', '#9e9e9e', '#607d8b'];
      const color = colors[index % colors.length];
      return hexStringColorToRgba(color, 0.3);
    },
  },
});
const itemNumbersPerRow = 4;
onMounted(async () => {
  await dict.functions.updateAdopterAddressList();
});
</script>

<template>
  <h3>Adoptoin!</h3>
  <a-button type="primary">Add new pet</a-button>
  <a-row v-for="(_,rowIndex) in (dict.data.adopterAddressList.length / itemNumbersPerRow)">
    <a-col 
        v-for="(_,ColumnIndex) in itemNumbersPerRow"
        :span="6"
        :style="{
            backgroundColor: dict.functions.getBackgroundColorByIndex(rowIndex * itemNumbersPerRow + ColumnIndex),
            height:'100px',
            width:'100px',
        }"
        class="flexCenter"
    >
        <div :style="{ height: '100%' }" class="flexCenter row">
            <div>{{ rowIndex * itemNumbersPerRow + ColumnIndex }}</div>
            <!-- <div>{{ dict.data.realAdopters[(rowIndex * itemNumbersPerRow + ColumnIndex)].name }}</div> -->
            <a-button
            ghost
            type="primary"
            size="small"
            @click=""
            >
            </a-button>
        </div>
    </a-col>
  </a-row>

</template>

<style></style>
