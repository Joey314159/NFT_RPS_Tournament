import React, { useState } from 'react';
import { getNFTOwner } from "../utils/contractServices";

const styles = {
    backgroundColor: 'rgb(153, 153, 153)',
    color: 'black',
    padding: '20px 40px',
    borderRadius: '5px',
    border: '2px',
    marginRight: '30px'
};


function GetNFTOwnerButton() {
    const [id, setId] = useState('');

    const handleSubmit = (event) => {
        event.preventDefault();
        getNFTOwnerG(id);
        console.log("Token ID Sent!");
    };

    const handleChange = (event) => {
        setId(event.target.value);
    };
    
    const getNFTOwnerG = async (tokenId) => {
        try {
            await getNFTOwner(tokenId);
        }
        catch (error) {
            console.log(tokenId);
            console.error("Can not retrieve owner of this nft", error);
        }
    };

    return (
        <form onSubmit={handleSubmit}>
            <label>Enter Token ID:
                <input type="text" value={id} onChange={handleChange}/>
            </label>
            <button style={styles} type="submit">Submit</button>

        </form>
        );
}

export default GetNFTOwnerButton;