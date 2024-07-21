async function main() {
  // Get the contract to deploy
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Compile the contract
  const shipping = await ethers.deployContract("Shipping");
  await shipping.waitForDeployment();

  console.log("Shipping contract address:", shipping.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
