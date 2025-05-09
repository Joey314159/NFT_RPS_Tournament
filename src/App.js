
import React, { useState } from "react";

import "./App.css";




function App() {


  return (
      <div className="container">
      <h1>Rock Paper Scissors Tournament</h1>

      <div className="actions">
          <button >Start Tournament</button>
          <button >Get Winner</button>
      </div>

      <div className="result">
          <h2>Winner:</h2>
          <p id="winnerAddress"></p>
      </div>
      </div>
  );
}

export default App;
