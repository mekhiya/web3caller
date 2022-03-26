//import React, { useState, useEffect } from "react"
import React, { useState } from "react"
//import { useEthers, useTokenBalance, useNotifications } from "@usedapp/core"
import { useEthers, useContractFunction } from "@usedapp/core"
//import { Button, Input, CircularProgress, Snackbar } from "@material-ui/core"
import { Button, CircularProgress, Input } from "@material-ui/core"
import { constants, utils } from "ethers"
//import Arch911 from "../chain-info/contracts/Arch911Contract.json"
import Arch911 from "../../chain-info/contracts/Arch911Contract.json"
import { Contract } from "@ethersproject/contracts"
import networkMapping from "../../chain-info/deployments/map.json"


export const DepositForm = () => {

    const { account } = useEthers()

    const [amount, setAmount] = useState<number | string | Array<number | string>>(0)
    const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        const newAmount = event.target.value === "" ? "" : Number(event.target.value)
        setAmount(newAmount)
        console.log(newAmount)
    }

    ////
    const { chainId } = useEthers()
    const { abi } = Arch911
    const arch911Address = chainId ? networkMapping[String(chainId)]["Arch911Contract"][0] : constants.AddressZero
    const arch911Interface = new utils.Interface(abi)
    const arch911Contract = new Contract(arch911Address, arch911Interface)


    const { state, send } = useContractFunction(arch911Contract, 'addDeposit', { transactionName: 'Add Deposit' })
    const { status } = state
    const isMining = status === "Mining"

    //const { send: depositSend, state: depositState } = useContractFunction(arch911Contract, "addDeposit", { transactionName: "Add Deposit", })
    const handleDepositSubmit = () => {
        const amountAsWei = utils.parseEther(amount.toString())
        //     //depositSend({ value: amountAsWei })
        send({ value: amount })
    }


    return (
        <>
            <div>
                <Input onChange={handleInputChange} />
                <Button onClick={handleDepositSubmit} color="primary" size="large" disabled={isMining}>
                    {isMining ? <CircularProgress size={26} /> : "Add Deposit"}</Button>
                <p>Status: {status}</p>
            </div>
            <div>
                New amount is {amount}
            </div>
        </>
    )

}