📘 Day 9 – CSS Positioning (Relative, Absolute, Fixed & Sticky)
📌 Overview

This project focuses on advanced CSS positioning techniques using a small image gallery.
The goal was to clearly understand and demonstrate the behavior of relative, absolute, fixed, and sticky positioning, along with hover interactions and captions.

🛠️ Technologies Used

HTML5

CSS3

🎯 Concepts Practiced
📐 CSS Positioning Types
Position	Description

relative	Positions element relative to itself

absolute	Positions element relative to nearest positioned ancestor

fixed	Positions element relative to viewport

sticky	Acts like relative until scroll threshold is reached


🖼️ Image Gallery Layout

Flexbox used for layout and wrapping

Each image wrapped in a reusable .img-box component

Clean separation of structure and styling

✨ Hover Interactions

Smooth scale animation

Drop shadow for depth

Caption appears on hover using opacity transition

.img-box:hover img {
    transform: scale(1.1);
}

.img-box:hover .caption {
    opacity: 1;
}

♿ Accessibility Improvements

Meaningful alt text for all images

Captions provide additional context

Clear visual feedback on hover

🔧 Key CSS Features Used

box-shadow

transform

transition

z-index

position properties

Flexbox layout