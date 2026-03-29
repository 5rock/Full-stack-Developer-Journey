# Day 22 – UI Components

## Overview
Reusable UI components are the building blocks of modern web interfaces. This project showcases a collection of commonly used UI components built with pure CSS, including buttons, cards, and layout utilities. These components can be easily copied and adapted for use in other projects.

## Concepts Covered
- **Buttons**: Primary, secondary, and outline button styles with hover states and disabled states
- **Cards**: Flexible card components with image support and compact variants
- **Layout styling**: Flexbox and Grid utilities for creating responsive layouts

## Usage Examples

### Buttons
```html
<button class="btn btn-primary">Primary Button</button>
<button class="btn btn-secondary">Secondary Button</button>
<button class="btn btn-outline">Outline Button</button>
```

### Cards
```html
<div class="card">
    <div class="card-image">
        <img src="image.jpg" alt="Card image">
    </div>
    <div class="card-content">
        <h3>Card Title</h3>
        <p>Card description</p>
        <button class="btn btn-primary">Action</button>
    </div>
</div>
```

### Layout Utilities
```html
<!-- Flexbox container -->
<div class="flex-container">
    <div class="flex-item">Item 1</div>
    <div class="flex-item">Item 2</div>
</div>

<!-- Grid container -->
<div class="grid-container">
    <div class="grid-item">Item 1</div>
    <div class="grid-item">Item 2</div>
</div>
```