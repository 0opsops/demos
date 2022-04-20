# Prerequisite tools

- AWS Cli
- Packer
- Terraform

## Query based AMI

```bash
    aws ec2 describe-images --owner $(aws ssm get-parameters \
    --names /aws/service/canonical/meta/publisher-id \
    --query 'Parameters[0].[Value]' \
    --output text)
```
