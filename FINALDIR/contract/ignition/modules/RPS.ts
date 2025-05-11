// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const RPSModule = buildModule("RPSModule", (m) => {
    const address = m.getParameter("address");

    const rps = m.contract("Main", [address] );

    return { rps };
});


export default RPSModule;