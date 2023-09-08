pragma solidity ^0.7.6;

import "hardhat/console.sol";

contract Adoption {
   struct PetStruct{
      //key가 map안에 존재한다면? 1이라는 값 할당
      uint256 keyExists;
      uint256 listIndex;
      //owner address(adopter,입영자)
      address owner;
   }
   //map의 key(string)은 petName이 옵니다
   mapping(string => PetStruct) public petsMap;
   string[] public petsList;

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

   function addNewPet(string memory petName)
      public returns (bool success){
         //petExists가 아니면, we will not add anything!!
         if(!isPetExists(petName)) return false;
         //add로직
         petsMap[petName].keyExists = 1;
         petsList.push(petName);
         petsMap[petName].listIndex = petsList.length - 1;
         // petsMap[petName].name = petName;

         return true;
   }

   address[16] public adopters;

   //adoption state거나 list의 내용이 변경될때마다 실행될 이벤트
   event APetGetAdopted(address indexed owner);

   function adopt(uint256 petId) public returns (uint256) {
        require(petId >= 0 && petId <= 15);
        adopters[petId] = msg.sender;

        emit APetGetAdopted(msg.sender);
        return petId;
   }

   function getAdopters() public view returns (address[16] memory){
    return adopters;
   }
}
