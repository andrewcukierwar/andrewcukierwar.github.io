# andrewcukierwar.github.io

Personal portfolio site for Andrew Cukierwar, a data scientist in New York. It's live at https://andrewcukierwar.github.io/.

It's a plain static site built with Bootstrap 4 and jQuery, served by GitHub Pages from the repository root. There's no build step, and the vendored libraries live in `vendor/`.

## Structure

| Path | Purpose |
| --- | --- |
| `index.html` | Main page: about, projects, experience, education, skills and earlier work |
| `visualizations.html` | Legacy D3.js and Processing visualizations (older academic work) |
| `resume.css`, `resume.js` | Site styles, smooth scrolling and scrollspy |
| `profile.jpg` | Sidebar photo |
| `vendor/` | Bootstrap, jQuery, jQuery Easing and Font Awesome |
| `Visualizations/` | Source and data for the legacy visualizations |
| `project/`, `SlimeVolleyball/`, `games/` | Older standalone projects, kept for reference and not linked from the main page |

## Local preview

Serve the repository root with any static file server, for example:

```sh
python3 -m http.server 8000
```

Then open http://localhost:8000. A server is needed rather than opening the file directly, because the visualizations load their CSV data over HTTP.

## Deployment

GitHub Pages publishes the `master` branch from the repository root. Merging to `master` deploys the site.
