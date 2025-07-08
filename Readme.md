# Dual Screen Slide Controller Setup Guide

## Project Structure
```
YourProject/
├── scenes/
│   ├── Main.tscn
│   └── SlideDisplayWindow.tscn
├── scripts/
│   ├── DualSlideController.gd
│   └── SlideDisplayWindow.gd
└── slides/
    ├── light/
    │   ├── slide_1.png
    │   ├── slide_2.png
    │   └── ...
    └── dark/
        ├── slide_1.png
        ├── slide_2.png
        └── ...
```

## Step 1: Export Slides from Google Slides

### Method A: Manual Export
1. Open your Google Slides presentation
2. Switch to **dark theme** in Google Slides (View > Theme > Dark)
3. Go to **File > Download > PNG image (.png, current slide)**
4. Export all slides and save in `/slides/dark/` folder
5. Switch to **light theme** in Google Slides
6. Repeat export process and save in `/slides/light/` folder
7. Name files sequentially: `slide_1.png`, `slide_2.png`, etc.

### Method B: Automated Export (Recommended for CGRA252)
Since you have the PDF, you can:
1. **Convert PDF to images**: Use a tool like `pdftoppm` or online converters
2. **Create light version**: Use image editing tools to invert/adjust colors
3. **Batch process**: Use ImageMagick or similar for automated light theme generation:
   ```bash
   # Convert dark slides to light theme
   for file in dark/*.png; do
     convert "$file" -negate -normalize "light/$(basename "$file")"
   done
   ```

### Method C: Direct PDF Integration
For academic presentations, you can modify the Godot script to load PDF pages directly using Godot's PDF support.

## Step 2: Set Up Godot Project

### Create Main Scene
1. Create a new scene with a **Node** as root
2. Name it "Main"
3. Attach the `scripts/DualSlideController.gd` script to the root node
4. Add two **TextureRect** nodes as children:
   - Name one "LightDisplay"
   - Name one "DarkDisplay"

### Configure Display Windows
1. Create a new scene with **Window** as root
2. Name it "SlideDisplayWindow"
3. Attach the `scripts/SlideDisplayWindow.gd` script
4. Instance this scene twice in your main scene for dual monitors

## Step 3: Configure the Controller

### Set File Paths
In the main controller, set:
- `light_slides_path = "res://slides/light/"`
- `dark_slides_path = "res://slides/dark/"`
- `slide_extension = ".png"`

### Input Controls
The system responds to:
- **Mouse**: Left click = next, Right click = previous, Scroll wheel = navigate
- **Keyboard**: Arrow keys, Space, Home, End, Escape
- **Custom**: Add gamepad or presentation remote support

## Step 4: Multi-Monitor Setup

### Option A: Separate Windows
```gdscript
# In your main scene's _ready() function
func _ready():
    # Create light theme window on monitor 0
    var light_window = preload("res://scenes/SlideDisplayWindow.tscn").instantiate()
    light_window.is_dark_theme = false
    light_window.monitor_index = 0
    add_child(light_window)
    
    # Create dark theme window on monitor 1
    var dark_window = preload("res://scenes/SlideDisplayWindow.tscn").instantiate()
    dark_window.is_dark_theme = true
    dark_window.monitor_index = 1
    add_child(dark_window)
```

### Option B: Single Window with Viewports
For more advanced control, use SubViewports to render to different monitors.

## Step 5: Advanced Features

### Slide Transitions
Add smooth transitions between slides:
```gdscript
func update_displays_with_transition():
    var tween = create_tween()
    tween.tween_property(light_display, "modulate:a", 0.0, 0.2)
    tween.tween_callback(func(): light_display.texture = light_slides[current_slide_index])
    tween.tween_property(light_display, "modulate:a", 1.0, 0.2)
```

### Presenter Tools
Add a presenter view with:
- Current slide preview
- Next slide preview
- Slide notes
- Timer
- Slide counter

### Remote Control
Integrate with:
- Presentation remotes via HID
- Mobile app control via HTTP server
- WebSocket for real-time control

## CGRA252-Specific Setup

Since you're working with Dr. McCallum's Game Engine Programming slides, here are some targeted recommendations:

### Academic Presentation Enhancements
1. **Add slide counter overlay** for easier navigation during lectures
2. **Include timer functionality** for pacing lessons
3. **Add presenter notes** display on a third monitor/window
4. **Keyboard shortcuts** for quick navigation (great for live coding demos)

### For CGRA252 Content
The slides cover topics like:
- Godot architecture and philosophy
- Event systems and game loops
- 2D game development
- Audio systems
- Comparison with Unity/Unreal

**Perfect use case**: When demonstrating Godot concepts, you can have:
- **Dark mode** on the main projector (easier on eyes in dark classroom)
- **Light mode** on student displays/handouts
- **Synchronized navigation** so both views stay in sync during demonstrations

### Quick Start for Your PDF
1. **Extract pages** from your PDF (19 slides total)
2. **Use existing dark theme** as your primary version
3. **Generate light version** automatically for accessibility
4. **Set up the Godot controller** with your extracted images
5. **Configure dual monitors** for classroom setup

### Export Settings
1. **Windows**: Create executable for Windows deployment
2. **macOS**: Build for macOS with proper display handling
3. **Linux**: Ensure X11/Wayland compatibility

### Performance Optimization
- Use compressed image formats (WebP, optimized PNG)
- Implement texture streaming for large presentations
- Cache management for memory efficiency

## Alternative: Web-Based Solution

If you prefer a web-based approach, consider:
1. Export slides as images from Google Slides
2. Create an HTML5 application with dual-screen support
3. Use Godot's web export for browser-based presentation

## Troubleshooting

### Common Issues
- **Slides not loading**: Check file paths and naming convention
- **Multi-monitor issues**: Verify monitor detection with `DisplayServer.get_screen_count()`
- **Input not working**: Ensure input handling is properly forwarded between windows

### Performance Tips
- Use appropriate image resolutions (1920x1080 for HD displays)
- Implement lazy loading for large slide sets
- Consider using Godot's streaming features for very large presentations

This setup gives you complete control over your dual-screen presentation with synchronized navigation and the flexibility to customize themes, transitions, and additional features as needed.