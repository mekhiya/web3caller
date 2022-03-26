import { useEtherBalance, useEthers, useTokenBalance } from "@usedapp/core"
import { formatEther } from '@ethersproject/units'

export const WalletBalance = () => {

    const { account } = useEthers()
    const userBalance = useEtherBalance(account)

    return (
        <div>
            This is WalletBalance
            {account && <p>Account: {account}</p>}
            {userBalance && <p>Ether balance: {formatEther(userBalance)} ETH </p>}
            {/* const formattedTokenBalance: number = tokenBalance ? parseFloat(formatUnits(tokenBalance, 18)) : 0 */}
        </div>
    )
}