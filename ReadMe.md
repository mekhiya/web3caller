Team : web3Caller
Team member - Nitin Mekhiya
Exploring multiple projects to submit for Ethernal Hackathon 2022.

Project 1 - Bill splitter. DApp that allows friends to split their bills in terms of ETH.
BlockPend

Project 2 - Smart Contract Analyser - DApp that analyses various paramemters and historical data to anlyse & rank qualities like 'decentrality', 'security', 'dependency', 'popularity'. Creates a dashboard with ranking. users can submit their deployed project for anylysing. Bot to scan popular smart contracts & create ranking


Project 3 - A/B testing - Tool that gives various option of data types / Events etc and tells you approximate gas spending

Projec 4 - EvEnt-log-IPFS based database

Project 5 - Pricefeed decimal and maths handler. Cuts confusion of maths while converting ETH to wei and other types.

Project 6 - create a smart contract which allows other smart contratcs to find sponsors and make their service free. 
BlockInfer
    - complete transparency about rules of getting sponsors. Contract decides who gets how much sponsorship.
    - BICoins (BIC) - governanace coins that are rewarded to sponsors according to how much they sponsor. 10 Millions (1 CR) is initial supply.
Actors - Sponsors, BIContract, Client-Contracts
Sponsors:
    - check dashboard
        sees list of contracts/companies that are looking for sponsorship. On clicking individual, they see details. 
    - check who's gets funds
        list of contracts who got sponsored through them.
    - allot sponsorship(accepted coins)
        add funds which will get used for sponsoring various contracts.
    - governance coins
        check their BI governance coins.
Contract
    - collects data for dashboard
    - sends money to ClientContract
    - allows clientcontracts to join the pool
ClientContracts
    - join pool
        submit their details for getting sponsors
    - request funds
        clients can start & pause their reception of funds.
    - send data
        sends regular data about how funds got used.
    - deposit stake
        clients have to deposit soem fund which is kept to control their check.

Dashboard - shows logo, company name, service description. Listing is done according to XYZ-factors(????). Can sponsors decide whom they want to give money? They can decide yes/no on factors, but cannot select individual company. Contract decides whom and how much money gets alloted according to formula. Approval of new client-contract is done by contract. So both Sponsors & client-contract owner fill form, but after that whole process is Contract driven.  

---Real-Time funding----

XYZ-factor 
    - for time being can be a simple formula for prototype. But eventually we can ad many more factors. 
    - request pledge signed by users of client-contract? different address gets to 
    - pledge request could be simple opensea like signing-cryto function & not actual tx. 
    - pledge reuqst could also be offchain, and submitted after certain period or after it reaches certain point.
    - transactions/address per month / per day / per week
    - xyz factor should look at number of nodes. Are these run independently.
    - how do you know if node is run by owner or are independent ???


Future features:
    - BICoins to handle governance. Can this coin be givence to sponsors?

sponsors - deposit warapped which gets used by contract. If value of client-contract goes up, wrapped value goes up, can you play something like that? Usually yield is based only on buy & sell. But over here yield is on top of real usage of network, and utility. So I(some sponsor) sponsored clients-contracts now those c-c did well their coins are more vauable, this increases my wrapped token values. So basically you are provisign temporary liquidity ot c-c. Sponsors are taking risks, they are basically investing in c-c. In short when you sponsor, you are buying coins of c-c.

GOVERNANCE TOKEN UTILITY 


How does C add funds to C-C. 

