# DecCert

This is the prototype implementation of DecCert: A decentralized public key infrastructure that solve's [Zooko's triangle](https://en.wikipedia.org/wiki/Zooko%27s_triangle).

Paper is avaiable [here](https://ieeexplore.ieee.org/abstract/document/9899851).

## Performance Results

Below is a table showing the gas amount for each transaction.

| Operation                | Cost in Gas Units |
|--------------------------|-------------------|
| Deployment               | 1666538           |
| Create a New Certificate | 202196            |
| Stake Certificate        | 69513             |
| Fraud Tag Certificate        | 86902             |
| Revoke Certificate       | 46681             |

## Warning 

**Do not attempt to deploy this contract.**

This code is for research purposes and is not audited. Moreover, it lacks an implementation of features to unlock funds; that is if you send funds to this contract they will be irrevocably lost. 


