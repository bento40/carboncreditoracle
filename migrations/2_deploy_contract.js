const Carboncredit = artifacts.require("Carboncredit");

module.exports = async function (deployer, _network, accounts) {
  await deployer.deploy(Carboncredit);
  const carboncredit = await Carboncredit.deployed();
};
