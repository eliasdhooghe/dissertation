# Artefact
Theoretical approach of building this artefact: link where dissertation is uploaded

---
### Installation dependencies
Install the Ganache UI from its website and create a private blockchain.

- Checking if node is installed: `node -v` If not install Node.js
- Installing truffle framework: `npm install -g truffle@5.6.8`
- Initialize truffle project in your directory: `truffle init`
- Extra dependencies are listed in package.json file. Install with NPM `npm install package.json`

### Running of project
Deleted: Run frontend:
npm run dev


## Setup artefact Remix IDE with Visual Studio Code
1. Open project in Visual Studio Code
2. Download the following extensions: Ethereum Remix,solidity, Truffle for VS Code
3. Go to the extension Ethereum Remix
4. Start remixd client and go to the website: https://remix.ethereum.org/
5. Change the workspace to connect to localhost. Press on connect.
6. The project structure is visible. Locate the contracts and use the tab Solidity compiler to compile the smart contracts.
7. After compiling, use the tab Deploy and run transactions to deploy contracts
8. Use the environment Ganache Provider to connect to the private blockchain network. Fill in the ganache JSON-RPC Endpoint of your private blockchain network: visible in the Ganache UI.
9. You are good to go
