# brightonsbox-environment

Terraform configuration for the brightonsbox.com website.

Using CircleCI pipeline to apply the Terraform changes.

## How to deploy

### Account Setup

Ensure the following are set up:

 * A [GitHub](https://github.com/brightonsbox) account.
 * A [CircleCI](https://circleci.com/) account, linked to GitHub
 * An [AWS](https://aws.amazon.com/) account
 * A [Terraform Cloud](app.terraform.io) account.

### AWS Setup

Then, create an IAM user for the Terraform provisioning 
with programmatic access. Keep a record of the access 
key ID and secret access key. Currently I have just given 
it the AmazonS3FullAccess policy. 

### Terraform Cloud UI Setup 

Navigate to the Teams section in your organization under 
Settings and choose "Create an authentication token" under 
Team API Token. Keep a record of the token.

Now create a workspace (this project requires it to be 
called brightonsbox-environment). Choose "No VCS connection".

Then create the following variables:

 * `region` - I am using `eu-west-2`
 * `user` - A username for CircleCI to use, I am using `circleci-user`
 * `bucket` - The name of the S3 bucket to use to host the site, 
 I am using `www.brightonsbox.com` 

Then create the following environment variables, using the
AWS credentials created earlier:

 * `AWS_ACCESS_KEY_ID` Set as sensitive.
 * `AWS_SECRET_ACCESS_KEY` Set as sensitive.
 * `CONFIRM_DESTROY` set to `1` (Allows CircleCI to run destroy operations)

### CircleCI Setup

Add the following environment variables:

 * `APP_BUCKET` - e.g. www.brightonsbox.com
 * `AWS_ACCESS_KEY_ID`
 * `AWS_SECRET_ACCESS_KEY`
 * `TF_API_TOKEN` - the Terraform API token recorded earlier
