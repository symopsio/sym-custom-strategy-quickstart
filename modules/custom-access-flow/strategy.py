from sym.sdk.strategies import AccessStrategy
from sym.sdk.integrations import slack
import requests


class CustomAccess(AccessStrategy):
    """This AccessStrategy is fully customizable, and contains basic implementations
    of all three required methods.
    """

    def fetch_remote_identity(self, user):
        # If the user doesn't have an identity already for this strategy, use
        # and save their email address as their identity. This will be returned by
        # self.get_requester_identity.
        return user.email

        # Example:
        # If the system you're escalating users in has its own user IDs, you might
        # fetch and return them here.
        # response = requests.post(
        #     "https://some-saas-product.com/api/v1/user-from-email",
        #     json={"email": user.email}
        # )
        # response_json = response.json()

        # if not response.ok:
        #     raise RuntimeError(f"Failed to fetch ID for {user.email}: {response_json['error']}")

        # return response_json["id"]

    def escalate(self, target_id, event):
        # Retrieve the user's identity for this strategy
        requester = self.get_requester_identity(event)

        # Retrieve the identifier field from the requested target's settings
        target_identifier = event.payload.fields["target"].settings["identifier"]

        # Message the requesting user on Slack that their access has been granted
        slack.send_message(slack.user(requester), f"Access to {target_identifier} granted!")

        # Example:
        # Here is where you might hit an external API to grant access to the requester
        # response = requests.post(
        #     "https://some-saas-product.com/api/v1/grant-access",
        #     json={"email": requester}
        # )

        # if not response.ok:
        #     raise RuntimeError(f"Failed to grant access: {response.json()['error']}")


    def deescalate(self, target_id, event):
        # Retrieve the user's identity for this strategy
        requester = self.get_requester_identity(event)

        # Retrieve the identifier field from the requested target's settings
        target_identifier = event.payload.fields["target"].settings["identifier"]

        # Message the requesting user on Slack that their access has been granted
        slack.send_message(slack.user(requester), f"Access to {target_identifier} revoked!")

        # Example:
        # Here is where you might hit an external API to revoke access from the requester
        # response = requests.post(
        #     "https://some-saas-product.com/api/v1/revoke-access",
        #     json={"email": requester}
        # )

        # if not response.ok:
        #     raise RuntimeError(f"Failed to revoke access: {response.json()['error']}")
