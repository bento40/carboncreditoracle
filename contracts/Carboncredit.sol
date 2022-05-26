// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;
pragma experimental ABIEncoderV2;

contract Carboncredit {
    mapping(string => address) public meter_owner; //mapping meter_api_key with metamask wallet

    // Smart Meter Data. Simplify version using only kWH.
    struct SmartMeter {
        string public_key;
        int256 tuya_get_emasure_energy; //Get the energy usage during a specified period that is set on the mobile app. Once the meter is read, the usage data will be zeroed out to start a new measuring cycle.
    }

    SmartMeter[] meter_data; //array of data from that smart meter per period

    mapping(address => SmartMeter[]) owner_data; //mapping meter data train with address
    mapping(address => int256) owner_carbon; //mapping carbon credit data with address

    // Link Metamask Wallet with IoT Device or centralize server data api (require call back to verify in the future)
    function linkDevice(string memory public_key) external {
        meter_owner[public_key] = msg.sender;
    }

    // get Public_Key for each address
    function getAddress(string memory public_key)
        public
        view
        returns (address)
    {
        return meter_owner[public_key];
    }

    // fetch data from iot device using oracle
    function fetchIotData(string memory public_key, int256 energy) external {
        address address_owner = getAddress(public_key);
        meter_data = owner_data[address_owner];
        meter_data.push(SmartMeter(public_key, energy));
        owner_data[address_owner] = meter_data;
    }

    // output smart meter data train
    function getData() public view returns (SmartMeter[] memory) {
        return owner_data[msg.sender];
    }

    // calculate carbon credit from energy efficiency read from smart meter. Simplify version
    function _calCarbon() public returns (int256) {
        SmartMeter[] memory meter_data1 = owner_data[msg.sender];
        uint256 meter_length = meter_data1.length;
        int256 energy_after = meter_data1[meter_length - 1]
            .tuya_get_emasure_energy;
        int256 energy_before = meter_data1[meter_length - 2]
            .tuya_get_emasure_energy;

        int256 carbon_offset = energy_after - energy_before;
        owner_carbon[msg.sender] = owner_carbon[msg.sender] + carbon_offset;
        return owner_carbon[msg.sender];
    }

    // output carbon credit of user
    function getCarbonCredit() public view returns (int256) {
        return owner_carbon[msg.sender];
    }

    // redeem carbon credit from approval metaverse
    function redeemCarbonCredit() external {
        owner_carbon[msg.sender] = 0;
    }
}
