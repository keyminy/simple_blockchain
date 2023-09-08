<script setup lang="ts">
import { log } from "console";
import { onMounted, reactive } from "vue";
import store from "../store";
import { hexStringColorToRgba } from "../utils";

const dict = reactive({
  tempdata: {
    showDialog: false,
  },
  data: {
    realAdopters: [] as any[],
    adopterAddressList: [] as string[],
    newPetName: ""
  },
  functions: {
    updateAdopterAddressList: async () => {
      const contract = await store.dict.functions.getAdoptionContract();
      // const adopterAddressList = await contract.getAdopterAddressList();
      const adoptersList = await contract.getAdopters();
      console.log('zzzzzzzz : ',adoptersList);
      
      dict.data.realAdopters = adoptersList.filter(item => item?.adopter != null);
      dict.data.adopterAddressList = dict.data.realAdopters.map(item => item.adopter);
    },
    getBackgroundColorByIndex: (index: number) => {
      const colors = ['#f44336', '#e91e63', '#9c27b0', '#673ab7', '#3f51b5', '#2196f3', '#03a9f4', '#00bcd4', '#009688', '#4caf50', '#8bc34a', '#cddc39', '#ffeb3b', '#ffc107', '#ff9800', '#ff5722', '#795548', '#9e9e9e', '#607d8b'];
      const color = colors[index % colors.length];
      return hexStringColorToRgba(color, 0.3);
    },
    isAdopted: (index: number) => {
      let adopterAddress = dict.data.adopterAddressList[index];
      if (adopterAddress === "0x0000000000000000000000000000000000000000") {
        return false;
      } else {
        return true;
      }
    },
    getButtonTextByIndex:(index: number) => {
      return dict.functions.isAdopted(index) ? "Adopted" : "Adopt"; 
    },
    adoptAPet: async (petName: string) => {
        const contract = await store.dict.functions.getAdoptionContract();
        const tx = await contract.adopt(petName);
        console.log('tx : ', tx);
        
    },
    addNewPet: async () => {
      const contract = await store.dict.functions.getAdoptionContract();
      const tx = await contract.addNewPet(dict.data.newPetName);
      console.log('tx : ', tx);
      
    },
    deleteTheLastPet : async () => {
      const contract = await store.dict.functions.getAdoptionContract();
      const tx = await contract.deletePet(
        dict.data.realAdopters[dict.data.realAdopters.length - 1].name
      );
      console.log('tx : ',tx);
    }
  },
});
const itemNumbersPerRow = 1;

onMounted(async () => {
  let contract = await store.dict.functions.getAdoptionContract();

  await dict.functions.updateAdopterAddressList();
  // console.log(dict.data.adopterAddressList);

  contract.on("APetGetAdopted",async (adopterAddress: string) => {
    console.log('APetGetAdopted event : ',adopterAddress);
    //refresh함.
    await dict.functions.updateAdopterAddressList();
  });

  contract.on("APetAdded",async (petName: string) => {
    console.log("APetAdded event : ",petName);
    
    await dict.functions.updateAdopterAddressList();
  });
  
});
</script>

<template>
  <h3>Adoptoin!</h3>
  <a-button type="primary"
  @click="dict.tempdata.showDialog = true">
    Add new pet
 </a-button>

  <a-modal
  v-model:visible="dict.tempdata.showDialog"
  title="Add new pet"
  @ok="async () => {
    await dict.functions.addNewPet();
    dict.tempdata.showDialog = false;
  }">
    <a-input v-model:value="dict.data.newPetName" 
    placeholder="Please input a pet name"/>
  </a-modal>
  <a-button type="danger" @click="dict.functions.deleteTheLastPet">Delete the last pet</a-button>
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
            <div>{{ dict.data.realAdopters[(rowIndex * itemNumbersPerRow + ColumnIndex)].name }}</div>
            <a-button
            ghost
            type="primary"
            size="small"
            :disabled="dict.functions.isAdopted(rowIndex * itemNumbersPerRow + ColumnIndex)"
            @click="dict.functions.adoptAPet(dict.data.realAdopters[(rowIndex * itemNumbersPerRow + ColumnIndex)].name)"
            >
                {{
                  dict.functions.getButtonTextByIndex(
                    rowIndex * itemNumbersPerRow + ColumnIndex
                  )
                }}
            </a-button>
        </div>
    </a-col>
  </a-row>

</template>

<style>
.flexCenter {
  display: flex;
  justify-content: center;
  align-items: center;
}
.row {
  display: flex;
  flex-direction: column;
}
</style>
