import {reactive} from "vue";
import { ethers } from "ethers";
import CounterJson from '../../artifacts/contracts/Counter.sol/Counter.json';
import AdoptionJson from '../../artifacts/contracts/Adoption.sol/Adoption.json';
import { Adoption, Counter } from '../../typechain';

const getProvider = async (): Promise<ethers.providers.Web3Provider> => {
    const window_ = window as any;
  
    // A Web3Provider wraps a standard Web3 provider, which is
    // what MetaMask injects as window.ethereum into each page
    const provider = new ethers.providers.Web3Provider(window_.ethereum)
  
    // MetaMask requires requesting permission to connect users accounts
    await provider.send("eth_requestAccounts", []);
  
    // The MetaMask plugin also allows signing transactions to
  // send ether and pay to change state within the blockchain.
  // For this, you need the account signer...
    //transaction을 보내기(send ether or pay)를 위해선 signer가 필요하다.
    // const signer = provider.getSigner();
  
    return provider
  };

export const dict = reactive({
    functions:{
        getCounterContract: async (): Promise<Counter> => {
            const provider = await getProvider();
          
            const signer = provider.getSigner()
          
            const contract = new ethers.Contract(
              "0x5FbDB2315678afecb367f032d93F642f64180aa3",
              CounterJson.abi,
              provider);
          
            return contract.connect(signer) as Counter;
          },
          getAdoptionContract: async (): Promise<Adoption> => {
            const provider = await getProvider();

            const signer = provider.getSigner()

            const contract = new ethers.Contract(
                "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512",
                AdoptionJson.abi,
                provider);

            return contract.connect(signer) as Adoption;
        }
    }
});

export default {getProvider, dict};
export type {Counter,Adoption};