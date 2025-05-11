import React from "react";
import { getPlayers } from "../utils/contractServices";

const styles = {
    backgroundColor: 'rgb(153, 153, 153)',
    color: 'black',
    padding: '20px 40px',
    borderRadius: '5px',
    border: '2px',
    marginRight: '30px'
};

function getPlayersButton() {
    const getPlayersG = async () =>  {
        try {
            await getPlayers();
        }
        catch (error) {
            console.error("Could not getplayers...", error);
        }
    };
    return(<button style={styles} onClick={getPlayersG}>Return Players</button>);
}

export default getPlayersButton;