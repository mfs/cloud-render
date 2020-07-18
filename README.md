# CLOUD-RENDER

## Note

As this script works best with the larger instance types set up an AWS billing
alert to catch any issues such as instances that don't terminate once they have
finished rendering.

## Description

This is a BASH script for performing Blender renders on AWS ec2 spot instances.
It assumes familiarity with AWS. Requirements on the AWS side are:

- An AWS account.
- An S3 bucket to use for storage of blend files and rendering artifacts.
- An IAM profile giving an ec2 instance access to the bucket.
- A security group allowing SSH access. Only for troubleshooting.
- An SSH key uploaded to AWS. Once again, just for troubleshooting.

Scripts are provided to automate the creation of the AMI, IAM Role and Security Group.

## Requirements

Besides the AWS requirements the following are required locally:

- aws cli (v1 tested, v2 should be ok too)
- packer (for AMI generation)

## Configuration

Configuration is via a config file located at `~/.config/cloud-render-rc`. See
`cloud-render-rc.template` for the required config parameters and below for a
description of them.

|Variable|Description|
|--------|-----------|
|CR_S3_BUCKET| S3 bucket to store `.blend` files and rendering artifacts. |
|CR_AMI| AMI that has Blender and system requirements pre installed. |
|CR_KEY| AWS SSH key to install on instance. |
|CR_SECURITY_GROUP| Security group for instance. I allow SSH for testing/troubleshooting.|
|CR_INSTANCE_TYPE| Instance type. e.g. `c5.9xlarge`|
|CR_IAM_INSTANCE_PROFILE| Instance profile giving instance access to the above S3 bucket. e.g. `arn:aws:iam::xxxxxxxxxxxx:instance-profile/cloud-render` |

## AMI Preparation

A packer script is supplied that will create an AMI using Amazon Linux 2 and
Blender 2.83.2. To build use the following commands from this directory:

    cd packer
    packer build amazon-linux-2-blender.json

This should output an AMI ID you can use in the `CR_AMI` config variable.

## IAM Role and Security Group

You can create these manually in the console and/or may have an existing
security group you can use. If not, a BASH script is supplied that will
create:

- An IAM role, `cloud-render` with a policy document allowing access to the `CR_S3_BUCKET`
- An Instance Profile, `cloud-render` that uses the above IAM role.
- A security group, `cloud-render`, that allows SSH in from *all* IPv4 addresses.

You may wish to use an alternative security group that is locked down to your
IP address.

To use the supplied BASH script execute the following commands from this
directory:

    cd aws
    ./create-iam-role-sg.sh

## Usage

To render setup your scene to use Cycles and call the script as follows:

    ./cloud-render scene.blend

This will render the first frame as a single image. Any further arguments will
be passed to Blender.

    ./cloud-render scene.blend -f 1 # same as the above example
    ./cloud-render scene.blend -a   # render animation as separate images

The original `.blend` file and the rendering artifacts are stored in S3 and
downloaded when complete. They are left in S3 if they need to be downloaded
again in future.

## TODO

- [ ] Add support for tweaking rendering settings via Python API.
- [ ] Support multiple Blender versions.
- [ ] Tighten up some of the permissions in the IAM profile.
