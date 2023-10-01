// import { HardhatUserConfig } from "hardhat/config";
// import "@nomicfoundation/hardhat-toolbox";

// const config: HardhatUserConfig = {
//   solidity: "0.8.19",
// };

// export default config;

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";

const config: HardhatUserConfig = {
  
 networks : {
  swisstronik : {
      url : "https://json-rpc.testnet.swisstronik.com/",
      accounts : [process.env.PRIVATE_KEY],
    },
 },

 solidity : {
  version : "0.8.19"
 }


};

export default config;
