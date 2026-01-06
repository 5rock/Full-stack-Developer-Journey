📘 Day 8 – CSS Display & Box Model

📌 Overview

Day 8 focuses on understanding CSS display properties and the CSS Box Model.
This practice helps explain how HTML elements behave on the page and how spacing, sizing, and layout are controlled using CSS.

🛠️ Technologies Used

HTML5

CSS3

✨ Topics Covered
🧱 Block-Level Elements

Used <div>, <h1>, and <p> as block elements

Observed how block elements:

Start on a new line

Take full width by default

<div class="section">
    <h1>Hello, World!</h1>
    <p>This is a sample HTML document.</p>
</div>

📦 CSS Box Model

Practiced how the box model works using:

width & height

padding

border

margin

box-sizing: border-box

* {
    box-sizing: border-box;
}

#box1 {
    width: 500px;
    height: 100px;
    padding: 55px;
    border: 10px solid red;
    margin: 15px;
}

🔀 Display Property

Compared inline, block, and inline-block

Used inline-block to allow:

Custom width/height

Margin and padding on inline elements

.spans span {
    display: inline-block;
    padding: 10px;
    margin: 8px;
}

📄 Page Features

Demonstrates block-level layout

Visual box model example

Inline vs inline-block comparison

Clean spacing and borders for clarity

📁 Folder Structure
day-7/
│
├── index.html
├── style.css
└── README.md

🧠 Learning Outcomes

Understood how block and inline elements behave

Learned how the CSS box model affects layout

Practiced box-sizing: border-box

Learned when to use inline-block

Improved layout control using margins and padding