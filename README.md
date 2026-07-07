# TFM-HERMION3

## Descripción

Repositorio de código correspondiente al Trabajo de Fin de Máster (TFM) del proyecto **HERMION-3**, centrado en el estudio de la respuesta a inmunoterapia en el carcinoma escamoso de cabeza y cuello (HNSCC) mediante análisis transcriptómico con el panel NanoString® nCounter PanCancer IO 360™, con especial atención a la vía de señalización STAT3.

## Estructura del repositorio
- **1.2_Analisis_NanoString_IO360.Rmd** — Análisis de los datos NanoString IO360 tras la normalización.
- **2_log2_Heatmap_PCA_after_norm.Rmd** — Transformación log2, generación de heatmap supervisado y análisis de componentes principales (PCA) tras la normalización.
- **3_analysis_DE_limma.Rmd** — Análisis de expresión diferencial mediante `limma`.
- **GSEA_analysis.Rmd** — Análisis de enriquecimiento de conjuntos génicos (GSEA).
- **Table_summary_DEGs.R** — Generación de la tabla resumen de genes diferencialmente expresados (DEGs).
- **kaplan-meiers.Rmd** — Análisis de supervivencia (curvas de Kaplan-Meier).
- **tabla_descriptiva_cohorte_HERMION.Rmd** — Tabla descriptiva de las características de la cohorte HERMION-3.

## Entorno de trabajo

- **R**: versión 4.5.3
- **RStudio**: versión 2025.09.2+418 "Cucumberleaf Sunflower"
- **Paquetes principales**: Bioconductor (procesamiento de datos ómicos y NanoString), `limma`, `patchwork`, `ggplot2`

## Autora

Júlia Francisco
