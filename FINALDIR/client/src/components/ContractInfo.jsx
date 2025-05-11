import React, { useEffect, useState } from "react";
import { getWinner } from "../utils/contractServices";

function ContractInfo() {
  const [winner, setWinner] = useState(null);

  useEffect(() => {
    const fetchWinner = async () => {
      const winner = await getWinner();
      setWinner(winner);    
    };
    fetchWinner();
  }, []);

  return (
    <div>
      <h2>Winner: {winner}</h2>
    </div>
  );
}

export default ContractInfo;