# Bisht Academic Theme for OJS

![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)
![OJS](https://img.shields.io/badge/OJS-3.3-green.svg)
![License](https://img.shields.io/badge/license-GPL--3.0-orange.svg)
![Price](https://img.shields.io/badge/price-free-brightgreen.svg)

A free, modern theme for [Open Journal Systems (OJS)](https://pkp.sfu.ca/ojs/), built for academic journals that care about clean presentation and indexing (Google Scholar, Crossref, DOAJ).

Developed by **[Yogesh Singh Bisht](https://digitalbisht.com/)** (**[LinkedIn](https://www.linkedin.com/in/yogeshsinghbisht/)**).

## Features

- **Responsive design** for desktop, tablet and mobile
- **4 color schemes**: Teal, Blue, Green, Purple
- **SEO and indexing metadata**: Google Scholar `citation_*` tags, Dublin Core, Schema.org JSON-LD, Open Graph and Twitter/X cards, correct canonical URLs
- **Article pages** with authors, ORCID links, abstract, keywords, downloads, "How to cite", and optional Altmetric / Dimensions badges
- **Homepage** with hero section, journal highlights, recent articles and current issue
- **Configurable footer**: social links, "Indexed in" badges, and your journal's own footer content
- **Accessible**: skip link, ARIA labels, keyboard-friendly navigation

## Requirements

- OJS **3.3.x**
- PHP **7.3** or newer

## Installation

### Option A: Upload in OJS (recommended)

1. Download **`bishtAcademicTheme-x.x.x.tar.gz`** from the [latest release](../../releases/latest). Use this file, not GitHub's green "Code > Download ZIP" button.
2. In OJS, go to **Settings > Website > Plugins** and click **Upload A New Plugin**.
3. Select the `.tar.gz` file and click **Save**.
4. Go to **Settings > Website > Appearance**, choose **Bisht Academic Theme** and click **Save**.

### Option B: Copy the files

1. Extract the release archive (or clone this repository).
2. Copy the folder to `plugins/themes/` in your OJS installation and name it `bishtAcademicTheme`, so you have `plugins/themes/bishtAcademicTheme/index.php`.
3. Enable the theme in **Settings > Website > Plugins**, then select it in **Settings > Website > Appearance**.

### Updating

Download the new release. In **Settings > Website > Plugins**, find **Bisht Academic Theme**, click the arrow next to it, choose **Upgrade** and select the new `.tar.gz` file. Your theme settings are kept.

## Configuration

The theme takes as much as possible from your normal OJS settings, so most journals only need to fill in a few fields.

### Filled in automatically from OJS

| What | Where OJS keeps it |
| --- | --- |
| Logo | *Settings > Website > Appearance > Logo*. If no logo is uploaded, the journal name is shown |
| Online / Print ISSN | *Settings > Journal > Masthead* |
| DOI prefix | DOI plugin settings (*Settings > Website > Plugins > DOI*), when the DOI plugin is enabled |
| Language | Submission languages (*Settings > Website > Setup > Languages*) |
| APC | Publication fee and currency (*Settings > Distribution > Payments*), when payments are enabled and the fee is above 0 |
| Article DOI, authors, ORCID, abstract, keywords, license | Each article's own metadata |
| Article views and downloads | OJS usage statistics |
| Altmetric / Dimensions badges | Looked up by the article's DOI |
| Footer content | *Settings > Website > Appearance > Page Footer*, shown above the copyright line |
| Main menu | *Settings > Website > Navigation* |

### Theme settings

All in **Settings > Website > Appearance > Theme**. Every field is optional and anything left empty is hidden.

| Setting | What it does |
| --- | --- |
| Color Scheme | Teal, Blue, Green or Purple |
| SEO Features | Turn JSON-LD, Open Graph and Twitter/X tags on or off |
| Altmetric and Dimensions Badges | Show third-party citation badges on article pages with a DOI |
| Highlights: DOI Prefix, Language, APC | Override the value taken from OJS. Enter `-` to hide the row |
| Highlights: Year Started, Publication Frequency | OJS has no field for these, so type them here, e.g. `2022` and `Monthly` |
| Indexed In | Comma-separated list, e.g. `Google Scholar, Crossref`. Shown as badges in the footer and on the homepage |
| Homepage Card: Title, Text, "Read More" Link | Optional third card on the homepage, e.g. "Continuous Publishing" or "Call for Papers" |
| Publication Ethics / Indexing / Google Scholar URLs | Links in the footer and homepage sidebar. Create the pages with the Static Pages plugin and paste their full address |
| Social profile URLs | Facebook, X (Twitter), LinkedIn, WhatsApp, Instagram, YouTube. Must start with `https://` |

> **Please be accurate with "Indexed In".** Only list services that index your journal today. DOAJ and other indexes treat false indexing claims as a serious problem.

## Security

This theme is designed to be safe to run on a public journal:

- Everything printed from journal, article or author data is HTML-escaped. Abstract and description excerpts are converted to plain text before they are shortened, so a cut can never leave an HTML tag open.
- Links entered by authors or editors (ORCID, license URL, social profiles) are only printed if they are real `http`/`https` URLs. ORCID links must point to `orcid.org`. `javascript:` and `data:` links are dropped.
- Schema.org JSON-LD is generated with PHP's `json_encode()` and cannot break out of its `<script>` tag.
- Author email addresses are **not** published in the page source.
- External links use `rel="noopener"`.
- The plugin's PHP files refuse direct web access.
- No tracking and no calls to the developer's servers. The only external resources are Font Awesome (cdnjs), Google Fonts and, if enabled, the Altmetric and Dimensions badges.

Found a security problem? Please report it privately as described in [SECURITY.md](SECURITY.md), not in a public issue.

## Support

- Questions and bug reports: [open an issue](../../issues)
- OJS setup, customisation and indexing help: [digitalbisht.com](https://digitalbisht.com/)

If this theme helps your journal, please ⭐ star the repository so other journals can find it.

## Credit

This theme is free. The footer shows a small credit:

> Developed by [Yogesh Singh Bisht](https://digitalbisht.com/)

Keeping this credit is the best way to say thanks and support further development.

## Changelog

### 1.1.0 (2026-11-06)

- Security: escaped all journal/article output, plain-text excerpts, validated ORCID/license/social URLs, JSON-LD built with `json_encode()`, author emails removed from meta tags, `rel="noopener"` on external links, direct-access guards on PHP files
- Removed the newsletter form, which did not send data anywhere. Replaced it with a link to OJS registration and email notifications
- Removed journal-specific hard-coded content (logo, DOI prefix, APC, indexing list, "Continuous Publishing" card, placeholder `#` links). The values are now taken from OJS settings where OJS stores them, and the rest are theme settings
- Fixed "Aims & scope" and "Indexing" links that pointed to pages OJS does not have
- Fixed canonical/`og:url` pointing every page at the homepage
- Fixed empty `<title>` on standard OJS pages
- Fixed `version.xml` class name so upload installation works
- Fixed theme option lists and missing labels in the settings form
- Added "Developed by Yogesh Singh Bisht" footer credit, support for the OJS Page Footer setting, and optional metric badges

### 1.0.0 (2025-12-26)

- First release

## License

Copyright (c) 2025-2026 Yogesh Singh Bisht

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. See the [LICENSE](LICENSE) file for the full text.

Open Journal Systems is developed by the [Public Knowledge Project](https://pkp.sfu.ca/).
