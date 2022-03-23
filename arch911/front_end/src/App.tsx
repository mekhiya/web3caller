import React from 'react';
import {
  //  Mainnet,
  DAppProvider,
  //  useEtherBalance,
  //  useEthers,
  Config,
  ChainId,
} from '@usedapp/core'
import { Header } from './components/Header';
//import { formatEther } from '@ethersproject/units'

function App() {
  return (
    <DAppProvider config={{
      supportedChains: [ChainId.Kovan, ChainId.Rinkeby]
    }}>
      <div>
        <Header />
        Hi!
      </div>
    </DAppProvider>
  );
}

export default App;
