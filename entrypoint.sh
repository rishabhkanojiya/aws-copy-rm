#!/bin/sh

set -e

if [ -z "$AWS_S3_BUCKET" ]; then
  echo "AWS_S3_BUCKET is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

# Default to us-east-1 if AWS_REGION not set.
if [ -z "$AWS_REGION" ]; then
  AWS_REGION="us-east-1"
fi

# Create a dedicated profile for this action to avoid conflicts
# with past/future actions.
aws configure --profile s3-copy-rm-profile <<-EOF >/dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

echo -e "\n-----Backing Up Files-------\n"

sh -c "aws s3 sync s3://${AWS_S3_BUCKET}/${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${DEST_DIR:-./backup}/$(date +%Y-%m-%d:%H-%M) \
              --exclude '*' --include 'js/*' --include 'asset-manifest.json' \
              --include 'static/*' --include 'css/*' --include 'translations/*' \
              --profile s3-copy-rm-profile \
              --no-progress"


aws configure --profile s3-copy-rm-profile <<-EOF >/dev/null 2>&1
null
null
null
text
EOF
