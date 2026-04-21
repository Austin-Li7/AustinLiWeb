project_root <- normalizePath(".", winslash = "/", mustWork = TRUE)
site_root <- file.path(project_root, "mywebsite")

target_qmd <- file.path(site_root, "projects", "project5-card-krueger-did", "index.qmd")
target_html <- file.path(site_root, "docs", "projects", "project5-card-krueger-did", "index.html")
listing_html <- file.path(site_root, "docs", "projects.html")

if (!file.exists(target_qmd)) {
  stop("Missing source file for Card & Krueger project page: ", target_qmd, call. = FALSE)
}

render_cmd <- paste(
  "HOME=/tmp",
  paste0("QUARTO_CACHE_DIR='", file.path(site_root, ".quarto-cache"), "'"),
  "quarto render",
  shQuote(normalizePath(site_root, winslash = "/", mustWork = TRUE))
)

render_status <- system(render_cmd, intern = TRUE, ignore.stderr = FALSE)

if (!file.exists(target_html)) {
  stop("Rendered project page not found: ", target_html, call. = FALSE)
}

if (!file.exists(listing_html)) {
  stop("Rendered projects listing not found: ", listing_html, call. = FALSE)
}

page_html <- paste(readLines(target_html, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
listing <- paste(readLines(listing_html, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

if (!grepl("Card &amp; Krueger", page_html, fixed = TRUE)) {
  stop("Rendered project page does not contain the expected title.", call. = FALSE)
}

if (!grepl("Diff-in-Diff", page_html, fixed = TRUE)) {
  stop("Rendered project page does not mention Diff-in-Diff.", call. = FALSE)
}

if (!grepl("project5-card-krueger-did/index.html", listing, fixed = TRUE)) {
  stop("Projects listing does not link to the new Card & Krueger page.", call. = FALSE)
}

if (!grepl("Assignment Checklist", page_html, fixed = TRUE)) {
  stop("Rendered project page is missing the assignment checklist section.", call. = FALSE)
}

if (!grepl("Sensitivity Check: Temporarily Closed Stores", page_html, fixed = TRUE)) {
  stop("Rendered project page is missing the sensitivity check section.", call. = FALSE)
}

if (!grepl("On this page", page_html, fixed = TRUE)) {
  stop("Rendered project page is missing the sidebar table of contents.", call. = FALSE)
}

if (!grepl("Replication Accuracy Check", page_html, fixed = TRUE)) {
  stop("Rendered project page is missing the replication accuracy check section.", call. = FALSE)
}

message("Card & Krueger page rendered and listed successfully.")
