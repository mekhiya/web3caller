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
import { Container } from "@material-ui/core"
import { Main } from './components/Main';
//import { formatEther } from '@ethersproject/units'

function App() {
  return (
    <DAppProvider config={{
      supportedChains: [ChainId.Kovan, ChainId.Mumbai]
    }}>
      <Header />
      <Container maxWidth="md">
        <div>
          <Main />
        </div>
      </Container>
    </DAppProvider>
  );
}

export default App;
