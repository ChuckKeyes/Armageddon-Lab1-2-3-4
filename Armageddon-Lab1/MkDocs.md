
### 1️⃣ Folder Layout (Recommended)

Inside your Obsidian vault (or a copy):

homework-site/
├─ docs/
│  ├─ index.md
│  ├─ lab1/
│  │  ├─ lab1a.md
│  │  ├─ diagram.png
│  ├─ images/
│  │  ├─ arch.png
├─ mkdocs.yml
📌 **Images stay relative** → no broken links.

---

### 2️⃣ Install MkDocs + Material Theme

pip install mkdocs mkdocs-material

3️⃣ Minimal `mkdocs.yml` (Obsidian-Friendly)

site_name: Homework – Keyes Cloud Solutions

theme:
  name: material
  features:
    - navigation.sections
    - navigation.expand
    - content.code.copy
    - content.tabs.link
    - content.admonition

markdown_extensions:
  - admonition
  - footnotes
  - tables
  - toc:
      permalink: true
  - pymdownx.details
  - pymdownx.superfences
  - pymdownx.highlight
  - pymdownx.inlinehilite
  - pymdownx.tasklist
  - pymdownx.emoji

nav:
  - Home: index.md
  - Lab 1:
      - Lab 1A: lab1/lab1a.md

💡 This preserves **Obsidian callouts** like:

`> [!note] > This works perfectly in MkDocs`

### 4️⃣ Preview Locally (Before S3)

`mkdocs serve`

Open:  
👉 `http://127.0.0.1:8000`

This step saves **hours of debugging**.

---

## ☁️ Deploy to S3 (Static Website)

### 5️⃣ Build Static HTML

`mkdocs build`

Output goes to:

`site/`

---

### 6️⃣ Create S3 Bucket

`aws s3 mb s3://homework1.keyescloudsolutions.com`

Enable static hosting (one-time):

`aws s3 website s3://homework1.keyescloudsolutions.com \   --index-document index.html \   --error-document 404.html`

---

### 7️⃣ Upload the Site

`aws s3 sync site/ s3://homework1.keyescloudsolutions.com --delete`

🎉 Done.

Your Obsidian-formatted homework is now live.

---

## 🌐 Optional (Highly Recommended Later)

|Feature|Why|
|---|---|
|CloudFront|HTTPS + caching|
|Custom domain|`homework7.keyescloudsolutions.com`|
|Versioned sites|Keep Lab 1, 2, 3 separate|
|GitHub Actions|Auto-publish on push|