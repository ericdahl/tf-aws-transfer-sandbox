# tf-aws-transfer-sandbox

This sets up an Internet-Facing endpoint in a VPC with a Security Group
allowing access from the provided CIDRs

```
$ terraform apply

$ sftp test-user@<endpoint from above>

sftp> ls
hello.txt
```

This has two options:
- service-managed users via SSH keys
- custom identity provider via Lambda


# Notes

- VPC Endpoint creates new PrivateLink Endpoint (ENI type) with associated SG
  attached
- Internet Facing = VPC with Elastic IPs also attached
- As of 2022-01-03
  - TF doesn't support custom hostnames (note: feature request not yet open)
- this uses SSH keys. If simple passwords were needed, a Custom Identity Provider
  could be used. This can either be a Lambda directly or API Gateway (REST type)

