# Spaces Notifier

A simple tool to execute scripts when changing macOS spaces.

`spaces-notifier` reads its configuration from `~/.sapces-notifier.json`. The root needs to be a dictionary containg an array of strings for the `commands` key. Every time the user switches to a different space, all of the commands are passed to `/bin/sh -c`.

```json
{
  "commands": [
    "path/to/script"
  ]
}
```