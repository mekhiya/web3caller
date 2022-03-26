import { useEthers } from "@usedapp/core"
import helperConfig from "../helper-config.json"
import networkMapConfig from "../chain-info/deployments/map.json"
import { constants } from "ethers"
import brownieConfig from "../brownie-config.json"
import { DepositForm } from "./YourWallet/DepositForm"
import { YourWallet } from "./YourWallet"


export const Main = () => {

    const { chainId } = useEthers()
    const networkName = chainId ? helperConfig[chainId] : "dev"

    const arch911ContractAddress = chainId ? networkMapConfig[String(chainId)]["Arch911Contract"][0] : constants.AddressZero

    const eth_usd_price_feed_address = chainId ? brownieConfig["networks"][networkName]["eth_usd_price_feed"] : constants.AddressZero

    console.log(chainId)
    console.log(networkName)

    return (
        <div>
            <div>Chain id is {chainId}</div>
            <div>networkName is {networkName}</div>
            <div>arch911ContractAddress is {arch911ContractAddress}</div>
            <div>eth_usd_price_feed_address is {eth_usd_price_feed_address}</div>
            {/* <YourWallet supportedTokens={supportedTokens} /> */}
            <YourWallet />

        </div>
    )
}