# Discourse Course Progress Plugin

A lightweight, server-side Discourse plugin designed to support LMS-style "course" progression. It exposes a single, highly-optimized API endpoint that returns the true historical read status of topics for the current user.

🎨 **Looking for the UI?** To actually display the progress badges and checkmarks in your Discourse sidebar, you must also install the official companion Theme Component: **[Discourse Course Progress Theme Component](https://github.com/zsviczian/discourse-course-progress-theme)**

## Why is this needed?
By default, the standard Discourse notification engine relies on a time-decay algorithm to prevent notification fatigue. It actively hides or ignores topics created *before* a user's account was created, making standard client-side scripts unable to track historical reading progress for new members.

This plugin bypasses the notification engine entirely. It queries the `TopicUser` database directly to find exactly which topics a user has historically opened, providing bulletproof data for custom UI theme components.

## Dependencies
This plugin relies on the official **Discourse Docs** plugin. It automatically tracks progress for any category that has an "Index Topic" configured in its Docs settings.

## Installation

1. SSH into your Discourse server.
2. Edit your `app.yml` file (e.g., `nano /var/discourse/containers/app.yml`).
3. Add the clone URL for this repository to the `hooks` section, placing it below `docker_manager`:

```yaml
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - git clone https://github.com/discourse/docker_manager.git
          - git clone https://github.com/zsviczian/discourse-course-progress.git
```

4. Rebuild the container:

```bash
cd /var/discourse
./launcher rebuild app
```

## Next Steps: Install the UI
Once your server finishes rebuilding, this plugin will quietly serve the progression data in the background. To make it visible to your users, install the **[Discourse Course Progress Theme Component](https://github.com/zsviczian/discourse-course-progress-theme)** via your Discourse Admin interface (`Admin > Customize > Themes > Install > From a Git Repository`).

---

## For Developers: API Endpoint
The plugin exposes one endpoint: `GET /course-progress.json`.
*(Note: The user must be logged in to access this endpoint, as guests do not have read histories).*

**Response Example:**

```json
{
  "courses": {
    "36": {
      "total_topics": 69,
      "read_count": 66,
      "read_topic_ids": [502, 503, 504]
    },
    "33": {
      "total_topics": 18,
      "read_count": 2,
      "read_topic_ids": [381, 382]
    }
  }
}
```