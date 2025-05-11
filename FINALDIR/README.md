# NFT_RPS_Tournament
 Creating a smart contract using the solidity programming language to create our own NFT and allow 4 users to join the tournament and compete against each other with a game of Rock, Paper, Scissors and the winner of the tournament will get our NFT for free

 Below is a guide to where some of the crucial directories are that contain integral files for the project.

## Directory
```
 /FINALDIR
    /client -> contains react app (frontend) for our project
        /src -> contains app source files 
            /components -> contains react components(buttons and elements)
            /utils -> contains necessary intermediary files to connect smart contract logic to components
    /contract -> contains smart contract and hardhat environment
        /contracts -> contains sol files
        /ignition -> deployment file
```
## Run Guide

To run our project:
 - Open 3 terminals.
 - First terminal: 
    - "cd client" launches the front end to localhost:3000
 - Second terminal: 
    - "npx hardhat node" launches the hardhat local node environment.
 - Third termminal: 
    - "npx hardhat ignition deploy ./ignition/modules/RPS.ts --network localhost --parameters ./ignition/parameters.json" deploys the contract.