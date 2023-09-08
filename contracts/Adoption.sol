pragma solidity ^0.7.6;
pragma abicoder v2;

import "hardhat/console.sol";

contract Adoption {
   struct PetStruct{
      //key가 map안에 존재한다면? 1이라는 값 할당
      uint256 keyExists;
      uint256 listIndex;
      string name;
      address adopter; //입양자
   }
   //map의 key(string)은 petName이 옵니다
   mapping(string => PetStruct) public petsMap;
   string[] public petsList;
   address[16] public adopters;
   //pet이 얼마나 있는지 count하는 함수
   function getPetListLength() public view returns (uint256 petCount) {
      return petsList.length;
   }

   //존재하는지?
   function isPetExists(string memory petName) public view returns (bool){
      // check if non-zero value in struct is zero
      // if it is zero then you know that myMapping[key] doesn't yet exist
      if(petsMap[petName].keyExists != 0){
         return true;//존재합니다
      }
      return false; //존재하지 않음
   }

   event APetAdded(string petName);

   function addNewPet(string memory petName)
      public returns (bool success){
         console.log("get in: add new pet function");
         //petExists가 아니면, we will not add anything!!
         if(!isPetExists(petName)) return false;
         //add로직
         petsMap[petName].keyExists = 1;
         petsList.push(petName);
         petsMap[petName].listIndex = petsList.length - 1;
         petsMap[petName].name = petName;

         emit APetAdded(petName);
         console.log("emit APetAdded: petName =", petName);
         return true;
   }
   
   function updatePet(string memory petName, address adopterAddress)
      public returns (bool success){
      
      if(!isPetExists(petName)) return false;

      petsMap[petName].adopter = adopterAddress;

      emit APetAdded(petName);
      return true;
   }

   function deletePet(string memory petName) public returns (bool success){
      if (!isPetExists(petName)) return false;
      //지워질 index
      uint256 indexToDelete = petsMap[petName].listIndex;
      string memory elementToMove = petsList[petsList.length - 1]; //petList의 마지막 원소
      petsList[indexToDelete] = elementToMove;
      petsMap[elementToMove].listIndex = indexToDelete;
      petsList.pop();
   }



   //adoption state거나 list의 내용이 변경될때마다 실행될 이벤트
   event APetGetAdopted(address indexed owner);

   function adopt(string memory petName) public returns (string memory) {
      /**old */
      //   require(petId >= 0 && petId <= 15);
      //   adopters[petId] = msg.sender;
      updatePet(petName,msg.sender);


      emit APetGetAdopted(msg.sender);
      return petName;
   }



   function getAdopters() public view returns (PetStruct[] memory){
    PetStruct[] memory tempList = new PetStruct[](petsList.length);
    for(uint256 i=0; i < petsList.length; i++){
      tempList[i] = petsMap[petsList[i]];
    }
    return tempList;
   }
}
