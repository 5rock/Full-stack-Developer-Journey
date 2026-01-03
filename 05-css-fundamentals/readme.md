📘 Day 5 – CSS Basics & Styling Methods
📌 Overview

Day 5 focuses on introducing CSS and understanding the different ways to style an HTML webpage.
This day demonstrates how inline CSS, internal CSS, and external CSS work together and how CSS selectors affect HTML elements.

🛠️ Technologies Used

HTML5

CSS3

✨ Topics Covered
🎨 Types of CSS
1️⃣ Inline CSS

Applied directly inside an HTML element using the style attribute.

<button style="color: blue;">Submit</button>

2️⃣ Internal CSS

Written inside the <style> tag in the <head> section.

<style>
    #Lorem {
        color: blue;
    }
</style>

3️⃣ External CSS

Written in a separate .css file and linked to the HTML document.

<link rel="stylesheet" href="style.css">

🎯 CSS Selectors Used

Element selector

h1 {
    color: blue;
}


ID selector

#welcome {
    font-weight: bold;
    font-size: 20px;
    text-align: center;
}


Global styling

body {
    background-color: #f0f0f0;
}

📄 Page Features

Styled headings using external CSS

Paragraph text formatting (font size, color, alignment)

ID-based styling for specific elements

Background color applied to the entire page

Demonstration of CSS priority (inline > internal > external)

📁 Folder Structure
day-5/
│
├── index.html
├── style.css
└── README.md

🧠 Learning Outcomes

Understood the three ways to apply CSS

Learned how CSS selectors work

Practiced linking external stylesheets

Learned about CSS priority and specificity

Improved page readability using styling

🚀 Future Improvements

Add class selectors

Create responsive layouts

Use Flexbox and Grid

Organize CSS for larger projects