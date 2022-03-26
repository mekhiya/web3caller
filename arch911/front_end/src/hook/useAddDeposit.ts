//import { useEffect, useState } from "react"
import { useEthers, useContractFunction } from "@usedapp/core"
import { constants, utils } from "ethers"
import Arch911 from "../chain-info/contracts/Arch911Contract.json"
import { Contract } from "@ethersproject/contracts"
import networkMapping from "../chain-info/deployments/map.json"

export const useAddDeposit = () => {

    // address
    // abi
    // chainId
    const { chainId } = useEthers()
    const { abi } = Arch911
    const arch911Address = chainId ? networkMapping[String(chainId)]["Arch911Contract"][0] : constants.AddressZero
    const arch911Interface = new utils.Interface(abi)
    const arch911Contract = new Contract(arch911Address, arch911Interface)

    //const [state, setState] = useState(approveAndStakeErc20State)

    const { send: depositSend, state: depositState } = useContractFunction(arch911Contract, "addDeposit", {
        transactionName: "Add Deposit",
    })

    return { depositState }
}