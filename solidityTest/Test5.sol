// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Test5 {
    function transTime(uint _n) public pure returns(string memory){
        uint sec = _n%60;
        uint min = (_n/60) % 60;
        uint hour = _n/(60*60);
        string memory ss = Strings.toString(sec);
        string memory sm = Strings.toString(min);
        string memory sh = Strings.toString(hour);

        if(keccak256(abi.encodePacked(sh))!=keccak256(abi.encodePacked("0"))){
            if(keccak256(abi.encodePacked(sm))!=keccak256(abi.encodePacked("0"))){
                return string(abi.encodePacked(sh, "hour ", sm, "min ", ss,"sec"));
            }
            else{
                if(keccak256(abi.encodePacked(ss))!=keccak256(abi.encodePacked("0"))){
                    return string(abi.encodePacked(sh, "hour ", ss,"sec"));
                }
                else{
                    return string(abi.encodePacked(sh, "hour "));
                }
            }
        }
        else if(keccak256(abi.encodePacked(sm))!=keccak256(abi.encodePacked("0"))){
            if(keccak256(abi.encodePacked(ss))!=keccak256(abi.encodePacked("0"))){
                return string(abi.encodePacked(sm, "min ", ss,"sec"));
                }
            else{
                return string(abi.encodePacked(sm, "min"));
            }
        }
        else{
            return string(abi.encodePacked(ss,"sec"));
        }
        
    }
}