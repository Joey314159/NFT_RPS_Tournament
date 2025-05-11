import React, { useState, useEffect } from "react";
import ConnectWalletButton from "./components/ConnectWalletButton";
import RunGameButton from "./components/RunButton";
import GetWinnerButton from "./components/GetWInnerButton";
import GetPlayersButton from "./components/GetPlayersButton";
import GetNFTOwnerButton from "./components/GetNFTOwnerButton";
import { requestAccount } from "./utils/contractServices";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import ContractInfo from "./components/ContractInfo";
import './app.css';


function App() {
  const [account, setAccount] = useState(null);

  useEffect(() => {
    const fetchCurrAccount = async () => {
      const account = await requestAccount();
      setAccount(account);
    };
    fetchCurrAccount();
  }, []);

  return (
    <div className="app">
      <ToastContainer />
      {!account ? (
        <ConnectWalletButton setAccount={setAccount} />
      ) : (
        <div className="appbox">
          <div className="text-box">
            <h1 className="title">RPS Emulator</h1>
          </div>
          <div className="contract-interactions">
            <RunGameButton className="buttons" />
            <GetWinnerButton/>
            <GetPlayersButton/>
            <GetNFTOwnerButton/>
          </div>
        </div>
        
      )}
    </div>
  );
}

export default App;