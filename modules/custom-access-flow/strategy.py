from sym.sdk.strategies import AccessStrategy
from sym.sdk.integrations import slack


class CustomAccess(AccessStrategy):
    def fetch_remote_identity(self, user):
        return user.email

    def escalate(self, target_id, event):
        requester = self.get_requester_identity(event)
        target_identifier = event.payload.fields["target"].settings["identifier"]
        slack.send_message(slack.user(requester), f"Access to {target_identifier} granted!")

    def deescalate(self, target_id, event):
        requester = self.get_requester_identity(event)
        target_identifier = event.payload.fields["target"].settings["identifier"]
        slack.send_message(slack.user(requester), f"Access to {target_identifier} revoked!")
