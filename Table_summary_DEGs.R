# ============================================================
# DEG SUMMARY TABLE - HERMION PROJECT
# gt + webshot2 → PNG
# ============================================================

# install.packages(c("gt", "webshot2"))
# webshot2 necessita Chrome instal·lat (normalment ja el tens)
# webshot2::webshot("https://www.google.com", "test.png")  # només la primera vegada

library(gt)
library(dplyr)
library(tibble)

# ── 1. DATA ──────────────────────────────────────────────────

table_data <- tribble(
  ~Comparison,                    ~All_Patients,                                  ~PDL1_pos,                                              ~pSTAT3_high,          ~pSTAT3_low, ~No_Oral_Cavity, ~Oral_Cavity,
  "Benefit vs No Benefit",        "—",                                            "—",                                                    "IL24, TWIST2, PRKX",  "N = 1",     "—",             "MAGEA4, IL4, TWIST2",
  "pSTAT3 high vs low",           "HLA-DQA1, HLA-DRB5,\nHLA-DQB1, KIR3DL2",     "HLA-DQA1, HLA-DRB5,\nHLA-DQB1, KIR3DL2,\nREN, IL21R", "N/A",                 "N/A",       "HLA-DRB5",      "N = 1",
  "RC vs PE",                     "MAGEA4",                                       "—",                                                    "IL24, WNT10A, PRKX",  "N = 1",     "—",             "MAGEA4, IL4",
  "Disease Control vs PE",        "—",                                            "—",                                                    "—",                   "—",         "—",             "IL4",
  "Responders vs Non-Responders", "—",                                            "—",                                                    "—",                   "—",         "—",             "IL4",
  "PD-L1+ vs PD-L1−",             "—",                                            "N/A",                                                  "—",                   "—",         "—",             "CDH1"
)

# ── 2. COLORS ────────────────────────────────────────────────

col_header  <- "#1B3A5C"
col_row_hdr <- "#EEF2F7"
col_no_deg  <- "#F0F4F8"
col_deg     <- "#FFFFFF"
col_blocked <- "#B0BAC5"
col_accent  <- "#C0392B"
col_warn    <- "#FEF9E7"
col_border  <- "#BDC7D3"

# ── 3. Funció per posar gens en cursiva ───────────────────────
# Separa per comes, posa cada gen en <i>, torna a unir

italicize_genes <- function(x) {
  # No transformar cel·les especials
  if (x %in% c("—", "N = 1", "N/A", "")) return(x)
  genes <- strsplit(x, ",\\s*")[[1]]
  paste(paste0("<i>", trimws(genes), "</i>"), collapse = ", ")
}

# ── 4. BUILD TABLE ────────────────────────────────────────────

gt_table <- table_data |>
  gt(rowname_col = "Comparison") |>
  
  # Capçaleres de columna
  cols_label(
    All_Patients   = html("<b>All Patients</b>"),
    PDL1_pos       = html("<b>PD-L1<sup>+</sup> patients</b>"),
    pSTAT3_high    = html("<b>pSTAT3 high</b><br><span style='font-weight:normal;font-size:10px'>patients</span>"),
    pSTAT3_low     = html("<b>pSTAT3 low</b><br><span style='font-weight:normal;font-size:10px'>patients</span>"),
    No_Oral_Cavity = html("<b>No Oral Cavity</b><br><span style='font-weight:normal;font-size:10px'>patients</span>"),
    Oral_Cavity    = html("<b>Oral Cavity</b><br><span style='font-weight:normal;font-size:10px'>patients</span>")
  ) |>
  
  # Totes les cel·les → fons gris clar per defecte
  tab_style(
    style = list(
      cell_fill(color = col_no_deg),
      cell_text(color = "#6C757D", align = "center", size = px(11))
    ),
    locations = cells_body()
  ) |>
  
  # Stub
  tab_style(
    style = list(
      cell_fill(color = col_row_hdr),
      cell_text(weight = "bold", size = px(11.5), align = "left")
    ),
    locations = cells_stub()
  ) |>
  
  # Capçaleres → blau fosc
  tab_style(
    style = list(
      cell_fill(color = col_header),
      cell_text(color = "#FFFFFF", weight = "bold", size = px(11.5), align = "center")
    ),
    locations = cells_column_labels()
  ) |>
  
  # Cantonada superior esquerra
  tab_style(
    style = list(
      cell_fill(color = col_header),
      cell_text(color = "#FFFFFF", weight = "bold", size = px(11))
    ),
    locations = cells_stubhead()
  ) |>
  
  # Cel·les N/A → gris fosc (text ocult, gt posarà el superíndex)
  tab_style(
    style = list(
      cell_fill(color = col_blocked),
      cell_text(color = col_blocked)
    ),
    locations = cells_body(columns = c(pSTAT3_high, pSTAT3_low), rows = 2)
  ) |>
  tab_style(
    style = list(
      cell_fill(color = col_blocked),
      cell_text(color = col_blocked)
    ),
    locations = cells_body(columns = PDL1_pos, rows = 6)
  ) |>
  
  # Cel·les N = 1 → groc pàl·lid + italic
  tab_style(
    style = list(
      cell_fill(color = col_warn),
      cell_text(color = "#7D6608", style = "italic", align = "center", size = px(10.5))
    ),
    locations = cells_body(columns = pSTAT3_low, rows = c(1, 3))
  ) |>
  tab_style(
    style = list(
      cell_fill(color = col_warn),
      cell_text(color = "#7D6608", style = "italic", align = "center", size = px(10.5))
    ),
    locations = cells_body(columns = Oral_Cavity, rows = 2)
  ) |>
  
  # ── Gens en cursiva (text_transform) ──────────────────────
  text_transform(
    locations = cells_body(columns = All_Patients),
    fn = function(x) sapply(x, italicize_genes)
  ) |>
  text_transform(
    locations = cells_body(columns = PDL1_pos),
    fn = function(x) sapply(x, italicize_genes)
  ) |>
  text_transform(
    locations = cells_body(columns = pSTAT3_high),
    fn = function(x) sapply(x, italicize_genes)
  ) |>
  text_transform(
    locations = cells_body(columns = No_Oral_Cavity),
    fn = function(x) sapply(x, italicize_genes)
  ) |>
  text_transform(
    locations = cells_body(columns = Oral_Cavity),
    fn = function(x) sapply(x, italicize_genes)
  ) |>
  # pSTAT3_low: només gens (no N=1 ni N/A)
  text_transform(
    locations = cells_body(columns = pSTAT3_low, rows = c(4, 5, 6)),
    fn = function(x) sapply(x, italicize_genes)
  ) |>
  
  # Cel·les AMB DEGs → blanc + text vermell negreta
  tab_style(
    style = list(cell_fill(color = col_deg),
                 cell_text(color = col_accent, weight = "bold", align = "center", size = px(11.5))),
    locations = cells_body(columns = pSTAT3_high,    rows = 1)
  ) |>
  tab_style(
    style = list(cell_fill(color = col_deg),
                 cell_text(color = col_accent, weight = "bold", align = "center", size = px(11.5))),
    locations = cells_body(columns = Oral_Cavity,    rows = 1)
  ) |>
  tab_style(
    style = list(cell_fill(color = col_deg),
                 cell_text(color = col_accent, weight = "bold", align = "center", size = px(11.5))),
    locations = cells_body(columns = All_Patients,   rows = 2)
  ) |>
  tab_style(
    style = list(cell_fill(color = col_deg),
                 cell_text(color = col_accent, weight = "bold", align = "center", size = px(11.5))),
    locations = cells_body(columns = PDL1_pos,       rows = 2)
  ) |>
  tab_style(
    style = list(cell_fill(color = col_deg),
                 cell_text(color = col_accent, weight = "bold", align = "center", size = px(11.5))),
    locations = cells_body(columns = No_Oral_Cavity, rows = 2)
  ) |>
  tab_style(
    style = list(cell_fill(color = col_deg),
                 cell_text(color = col_accent, weight = "bold", align = "center", size = px(11.5))),
    locations = cells_body(columns = All_Patients,   rows = 3)
  ) |>
  tab_style(
    style = list(cell_fill(color = col_deg),
                 cell_text(color = col_accent, weight = "bold", align = "center", size = px(11.5))),
    locations = cells_body(columns = pSTAT3_high,    rows = 3)
  ) |>
  tab_style(
    style = list(cell_fill(color = col_deg),
                 cell_text(color = col_accent, weight = "bold", align = "center", size = px(11.5))),
    locations = cells_body(columns = Oral_Cavity,    rows = 3)
  ) |>
  tab_style(
    style = list(cell_fill(color = col_deg),
                 cell_text(color = col_accent, weight = "bold", align = "center", size = px(11.5))),
    locations = cells_body(columns = Oral_Cavity,    rows = 4)
  ) |>
  tab_style(
    style = list(cell_fill(color = col_deg),
                 cell_text(color = col_accent, weight = "bold", align = "center", size = px(11.5))),
    locations = cells_body(columns = Oral_Cavity,    rows = 5)
  ) |>
  tab_style(
    style = list(cell_fill(color = col_deg),
                 cell_text(color = col_accent, weight = "bold", align = "center", size = px(11.5))),
    locations = cells_body(columns = Oral_Cavity,    rows = 6)
  ) |>
  
  # Vores
  tab_style(
    style = cell_borders(sides = "all", color = col_border, weight = px(1)),
    locations = list(cells_body(), cells_stub())
  ) |>
  tab_style(
    style = cell_borders(sides = "bottom", color = col_header, weight = px(2.5)),
    locations = cells_column_labels()
  ) |>
  
  # Amplades
  cols_width(
    Comparison     ~ px(175),
    All_Patients   ~ px(135),
    PDL1_pos       ~ px(155),
    pSTAT3_high    ~ px(130),
    pSTAT3_low     ~ px(110),
    No_Oral_Cavity ~ px(125),
    Oral_Cavity    ~ px(135)
  ) |>
  
  # Títol
  tab_header(
    title    = md("**Summary of Differentially Expressed Genes (DEGs) by Subgroup**"),
    subtitle = md("HERMION cohort · NanoString IO360 panel · *p* < 0.05 and Log₂FC > 1 (limma, unadjusted)")
  ) |>
  
  # ── Footnotes: sense <sup> manual, gt els numera sol ────────
  tab_footnote(
    footnote  = "Subgroup too small for valid comparison (N = 1); results not reported.",
    locations = cells_body(columns = pSTAT3_low, rows = 1)
  ) |>
  tab_footnote(
    footnote  = "Subgroup too small for valid comparison (N = 1); results not reported.",
    locations = cells_body(columns = pSTAT3_low, rows = 3)
  ) |>
  tab_footnote(
    footnote  = "Subgroup too small for valid comparison (N = 1); results not reported.",
    locations = cells_body(columns = Oral_Cavity, rows = 2)
  ) |>
  tab_footnote(
    footnote  = "Not applicable: subgroup column matches the comparison variable.",
    locations = cells_body(columns = pSTAT3_high, rows = 2)
  ) |>
  tab_footnote(
    footnote  = "Not applicable: subgroup column matches the comparison variable.",
    locations = cells_body(columns = PDL1_pos, rows = 6)
  ) |>
  
  tab_source_note(
    source_note = md("RC: complete response. RP: partial response. EE: stable disease. PE: progressive disease. Responders: RC + RP. Non-Responders: EE + PE. PD-L1⁺: CPS ≥ 1. DEG threshold: *p* < 0.05 and Log₂FC > 1 (limma, unadjusted).")
  ) |>
  
  # Opcions
  tab_options(
    table.border.top.color             = col_header,
    table.border.top.width             = px(3),
    table.border.bottom.color          = col_border,
    heading.title.font.size            = px(13),
    heading.subtitle.font.size         = px(10.5),
    heading.border.bottom.color        = col_border,
    column_labels.border.bottom.width  = px(2),
    stub.border.width                  = px(1.5),
    stub.border.color                  = col_border,
    footnotes.font.size                = px(10),
    source_notes.font.size             = px(10),
    data_row.padding                   = px(9),
    table.font.names                   = "Arial"
  )

# ── 5. EXPORT ─────────────────────────────────────────────────

gtsave(gt_table,
       filename = "C:/Users/socla/Documents/results/07_Results_DEG_Limma/DEG_summary_table.png",
       vwidth   = 1050,
       vheight  = 640,
       zoom     = 2)

cat("✓ Taula guardada.\n")