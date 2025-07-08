# Developer Instructions for Godot Tasks

This document lists tasks from `todo.md` that need to be completed using the Godot editor. Use it as a checklist while working in the project.

## Scene Setup
- [ ] Open `scenes/Main.tscn` and finish building the main scene:
  - Add two `TextureRect` nodes named `LightDisplay` and `DarkDisplay`.
  - Instance `SlideDisplayWindow.tscn` twice if using separate windows for each monitor.
  - Attach `scripts/DualSlideController.gd` to the root node.

- [ ] Open `scenes/SlideDisplayWindow.tscn` and configure the root `Window` node:
  - Ensure the `SlideDisplayWindow.gd` script is attached.
  - Set up anchors so that the `TextureRect` child fills the window.

## Script Integration
- [ ] Implement gamepad or presentation remote input in `DualSlideController.gd`.
- [ ] Add slide transition effects (e.g., fade) when updating displays.
- [ ] Create fullscreen/windowed toggle logic in `SlideDisplayWindow.gd`.
- [ ] Add logic to spawn windows for each detected monitor.
- [ ] Handle monitor disconnect/reconnect events gracefully.

## Presenter Tools
- [ ] Add a slide counter overlay (Label node) that updates via `update_slide_counter()`.
- [ ] Implement a timer node with start/stop/reset buttons for presentations.
- [ ] Create a notes system (e.g., `RichTextLabel`) for presenter-only text.
- [ ] Add quick navigation thumbnails using `GridContainer` and preview images.

## Multi-Monitor Features
- [ ] Auto-detect monitors with `DisplayServer.get_screen_count()`.
- [ ] Synchronize slide updates across all display windows using the `slide_changed` signal.
- [ ] Expose monitor assignment in `SlideDisplayWindow.gd` via exported variables.

## Testing in Godot
- [ ] Verify slide navigation works with mouse, keyboard, and gamepad.
- [ ] Ensure slides display correctly on multiple monitors.
- [ ] Test window resizing and fullscreen mode on all platforms.

Keep this document updated as tasks are completed.
