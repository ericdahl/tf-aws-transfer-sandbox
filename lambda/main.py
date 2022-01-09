import json
import os

print('Loading function')


def handler(event, context):
    # logs password; not for production use
    print("Received event: " + json.dumps(event, indent=2))

    # also not for production use, obviously
    if "password" in event and event["password"] == "password":  # super secret
        # successful
        return {
            "Role": os.environ["AWS_TRANSFER_USER_ROLE"],
            # Important. This is optional but if omitted, requires operations
            # to be fully qualified or "cd" into "/bucket" first
            "HomeDirectory": "/" + os.environ["S3_BUCKET_NAME"]
        }
    else:
        # failed login
        return {}
