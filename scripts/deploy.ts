import { ethers } from "hardhat";

async function main() {


  const [deployer] = await ethers.getSigners();
  console.log("Deploying contract with account", deployer.address);

  const MyContract= await ethers.getContractFactory("SimpleVoting");
  const contract=await MyContract.deploy();
  console.log("Contract Address", contract.target);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
