import React from "react";
import { requestAccount } from "../utils/contractServices";

function ConnectWalletButton({setAccount}) {
    const connectWallet = async () => {
        try{
            const account = await requestAccount();
            setAccount(account);
        }
        catch (error) {
            console.error("Cant get wallet info", error);
        }
    };
    return <button onClick={connectWallet}>Connect Wallet</button>;
}

export default ConnectWalletButton;