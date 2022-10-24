import { ethers } from "ethers";

import RewardFactoryAbi from './abi/RewardFactory.json';
import RewardNftAbi from './abi/RewardNFT.json';
import GeneratedAddresses from './genAddresses.json';

export const contractAddresses = {
  "rewardFactory" : GeneratedAddresses.jobFactory,
}

async function getEtherEssentials(){
  const userAddress = window.ethereum.selectedAddress
  const provider = new ethers.providers.Web3Provider(window.ethereum)
  const signer = provider.getSigner()

  return {
    provider,
    signer,
    userAddress
  }
}

export async function getJobRelatedContracts(){
  const { provider,signer,userAddress } = await getEtherEssentials()

  const factoryContract = new ethers.Contract(contractAddresses.rewardFactory, RewardFactoryAbi, provider);
  const nftAddress = await factoryContract.nft()
  const nftContract = new ethers.Contract(nftAddress, RewardNftAbi, provider);

  return {
    provider,
    signer,
    factoryContract,
    nftAddress,
    nftContract,
    userAddress,
  }
}
