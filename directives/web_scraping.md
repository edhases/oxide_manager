# Directive: Web Scraping with Firecrawl

## Goal
Automate the extraction of structured data from websites (e.g., GitHub releases, product pages) using Firecrawl MCP.

## Inputs
- `url`: The target website URL.
- `format`: Desired output format (default: `markdown`).
- `schema`: (Optional) JSON schema for structured extraction.

## Layer 3 Tools (Execution)
- `execution/scrape_content.py`: Basic script to trigger Firecrawl scrape.
- `execution/batch_scrape.py`: For multiple URLs.

## Workflow
1. Check if `FIRECRAWL_API_KEY` is set in `.env`.
2. Run the appropriate script from `execution/`.
3. Save results to `.tmp/`.
4. Update this directive if site structure changes or rate limits are hit.

## Edge Cases
- **Rate Limiting**: Use backoff strategies defined in Firecrawl docs.
- **Dynamic Content**: Use `waitFor` parameter for JS-heavy sites.
- **No Access**: Check if the site requires authentication or has robots.txt restrictions.
