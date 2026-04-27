# Discourse Course Progress

A lightweight, server-side Discourse plugin designed to support LMS-style "course" progression. It exposes a single, highly-optimized API endpoint that returns the true historical read status of topics for the current user.

## Why is this needed?
By default, the Discourse notification engine (and `/unread.json`) relies on a time-decay algorithm to prevent notification fatigue. It actively hides or ignores topics created *before* a user's account was created, making client-side scripts unable to track historical reading progress for new members.

This plugin bypasses the notification engine entirely. It queries the `TopicUser` database directly to find exactly which topics a user has historically opened, providing bulletproof data for custom UI theme components (like sidebar progress bars or Unread dots).

## Dependencies
This plugin relies on the official **Discourse Docs** plugin. It specifically tracks progress for categories that have an "Index Topic" configured in their Docs settings.

## Installation

1. SSH into your Discourse server.
2. Edit your `app.yml` file (`nano /var/discourse/containers/app.yml`).
3. Add the clone URL for this repository to the `hooks` section:

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

## API Endpoint
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

## Usage in Theme Components
You can now easily add notification dots or progress bars in your Theme Component's Javascript:

```javascript
fetch('/course-progress.json')
  .then(response => response.json())
  .then(data => {
      const courses = data.courses;
      if (courses["36"]) {
          const unreadTotal = courses["36"].total_topics - courses["36"].read_count;
          if (unreadTotal > 0) {
              console.log("User still needs to complete this course!");
              // Draw your UI notification dot here
          }
      }
  });
```
