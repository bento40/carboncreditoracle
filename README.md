# Net Zero Carbon Credit Oracle

This is the example code structure to present the idea for Net Zero Carbon Credit Oracle where small sustainability activities that inline with carbon credit calculation is recored in a decentralized and transparent way for future benefit as well as future validation for tradable voluntary carbon credit.

![alt text](https://github.com/bento40/carboncreditoracle/blob/master/schematic.png?raw=true)

## Installation

There are two ways to run the code. First, copy carboncredit.sol to [Remix IDE](https://remix.ethereum.org/) or run using truffle
Install Node.

```bash
nvm install node --reinstall-packages-from=node
```

Install Truffle.

```bash
npm install -g truffle
```

Deploy Smart Contract.

```bash
truffle develop
```

## Demo Usage

The smart contract is an example of smart meter to gain carbon credit from energy efficiency (reduce usage and optimize energy) it can be apply to other iot device with a few change in calculation of carbon credit. The flow of function shall be as follow;

![alt text](https://github.com/bento40/carboncreditoracle/blob/master/flow.png?raw=true)

1. Connect IoT device or Data from server with Metamask wallet of user. Call back function may required in order to get confirm information from otherside

```solidity
    // Link Metamask Wallet with IoT Device or centralize server data api (require call back to verify in the future)
    function linkDevice(string memory public_key) external {
        meter_owner[public_key] = msg.sender;
    }
```

2. Fetch data from IoT device or Server

```solidity
    // fetch data from iot device using oracle
    function fetchIotData(string memory public_key, int256 energy) external {
        address address_owner = getAddress(public_key);
        meter_data = owner_data[address_owner];
        meter_data.push(SmartMeter(public_key, energy));
        owner_data[address_owner] = meter_data;
    }
```

3. Calculate Carbon credit

```solidity
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
```

4. Redeem Carbon credit function and reset to 0

```solidity
    // redeem carbon credit from approval metaverse
    function redeemCarbonCredit() external {
        owner_carbon[msg.sender] = 0;
    }
```

## Full version note

Full version shall include -integrate with real device as well as NetZero Metaverse - have ERC-721 Carbon credit issuer to be able to trade on NFT market - burn with each metaverse - store data in IPFS. It is under development
