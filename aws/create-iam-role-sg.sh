#!/usr/bin/bash

set -e

# shellcheck source=/dev/null
source ~/.config/cloud-render-rc

aws iam create-role --role-name cloud-render --assume-role-policy-document \
"{ \
  \"Version\": \"2012-10-17\", \
  \"Statement\": { \
    \"Effect\": \"Allow\", \
    \"Principal\": {\"Service\": \"ec2.amazonaws.com\"}, \
    \"Action\": \"sts:AssumeRole\" \
  } \
}"

aws iam put-role-policy --role-name cloud-render --policy-name cloud-render-s3 --policy-document \
"{ \
    \"Version\": \"2012-10-17\", \
    \"Statement\": [ \
        { \
            \"Sid\": \"VisualEditor0\", \
            \"Effect\": \"Allow\", \
            \"Action\": \"s3:*\", \
            \"Resource\": [ \
                \"arn:aws:s3:::$CR_S3_BUCKET\", \
                \"arn:aws:s3:::$CR_S3_BUCKET/*\" \
            ] \
        } \
    ] \
}"

aws iam create-instance-profile --instance-profile-name cloud-render

aws iam add-role-to-instance-profile --instance-profile-name cloud-render --role-name cloud-render

aws ec2 create-security-group --group-name cloud-render --description "cloud render ssh"

aws ec2 authorize-security-group-ingress --group-name cloud-render --protocol tcp --port 22 --cidr 0.0.0.0/0
