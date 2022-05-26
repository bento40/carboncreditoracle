// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;
pragma experimental ABIEncoderV2;

contract Carboncredit {

    //mapping(address => string) public meter;

    mapping(string => address) public meter_owner;

    struct SmartMeter {
        string public_key; 
        //uint256 tuya_dev_measure_reg;	    //Register parameters of energy metering.
        //bool    tuya_dev_measure_start;	    //Enable the energy metering feature.
        int tuya_get_emasure_energy;	    //Get the energy usage during a specified period that is set on the mobile app. Once the meter is read, the usage data will be zeroed out to start a new measuring cycle.       
    }

    SmartMeter[] meter_data;    //array of data from that smart meter

    mapping(address => SmartMeter[])  owner_data;
    mapping(address => int) owner_carbon;

    //Link Metamask Wallet with IoT Device 1 user per 1 device (require call back to verify)
    function linkDevice(string memory public_key) external {
        meter_owner[public_key] = msg.sender;
    }
    //get Public_Key for each address 
    function getAddress(string memory public_key) public view returns(address) {
        return meter_owner[public_key];
    }
    
    function fetchIotData(string memory public_key, int energy) external {
        address address_owner = getAddress(public_key); 

        meter_data = owner_data[address_owner];

        //uint256 meter_length = meter_data.length;
 
        meter_data.push(SmartMeter(public_key,energy));

        owner_data[address_owner] = meter_data;

        //calculate carbon credit from fetch data
        // if (meter_length != 0){
        // uint256 energy_before = meter_data[meter_length].tuya_get_emasure_energy;
        // _calCarbon(address_owner, energy_before, energy);
        // }
    }

    function getData() public view returns(SmartMeter[] memory){
        return owner_data[msg.sender];
    }

    //function _calCarbon(address owner, uint256 carbon_before, uint256 carbon_after ) private {
    function _calCarbon() public returns(int) {
    
        // uint256 carbon_offset = carbon_before - carbon_after ;
        // if (carbon_offset > 0){
        //     owner_carbon[owner] = carbon_offset;
        // }
        // external
        SmartMeter[] memory meter_data1 = owner_data[msg.sender];
        uint256 meter_length = meter_data1.length;
        int energy_after = meter_data1[meter_length-1].tuya_get_emasure_energy;
        int energy_before = meter_data1[meter_length-2].tuya_get_emasure_energy;

        int carbon_offset = energy_after - energy_before ;
        owner_carbon[msg.sender] = owner_carbon[msg.sender]+carbon_offset;
        return owner_carbon[msg.sender];

        // if (carbon_offset < 0){
        //     owner_carbon[msg.sender] = owner_carbon[msg.sender]-carbon_offset;
        // }
    }

    function getCarbonCredit() public view returns(int){
        return owner_carbon[msg.sender];
    }

    function redeemCarbonCredit() external{
        owner_carbon[msg.sender] = 0;
    }
}