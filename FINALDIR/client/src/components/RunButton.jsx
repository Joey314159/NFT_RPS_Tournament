import React from "react";
import { run } from "../utils/contractServices";

const styles = {
    backgroundColor: 'rgb(153, 153, 153)',
    color: 'black',
    padding: '20px 40px',
    borderRadius: '5px',
    border: '2px',
    marginRight: '30px'
};

function runGameButton() {
    const runGame = async () =>  {
        try {
            await run();
        }
        catch (error) {
            console.error("Could not run the game...", error);
        }
    };
    return(<button style={styles} onClick={runGame}>Start the Game</button>);
}

export default runGameButton;