const fs = require('fs');
const path = require('path');
const hre = require("hardhat");

async function main() {

  const RewardFactory = await ethers.getContractFactory("RewardFactory");
  const rewardFactoryContract = await RewardFactory.deploy(clientNftAddress,freelancerNftAddress);
  await rewardFactoryContract.deployed();

  console.log("rewardFactoryContract deployed to:", rewardFactoryContract.address);

  const content = {
    "rewardFactory" : rewardFactoryContract.address,
  }
  createAddressJson(path.join(__dirname, '/../app/genAddresses.json'),JSON.stringify(content))

}

function createAddressJson(path,content){
  try{
    fs.writeFileSync(path,content)
    console.log("Created Contract Address JSON")
  } catch (err) {
    console.error(err)
    return
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
