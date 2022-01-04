# tf-aws-transfer-sandbox

This sets up an Internet-Facing endpoint in a VPC with a Security Group
allowing access from the provided CIDRs

```
$ terraform apply

$ sftp test-user@<endpoint from above>
```


# Notes

- As of 2022-01-03
  - TF doesn't support custom hostnames (note: feature request not yet open)
- this uses SSH keys. If simple passwords were needed, a custom API Gateway could
  be used as the identity provider

