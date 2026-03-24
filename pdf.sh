#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_PDF="${SCRIPT_DIR}/Bedlam.pdf"
MANUSCRIPT_MD="${SCRIPT_DIR}/MANUSCRIPT.md"
COVER_IMAGE="${SCRIPT_DIR}/cover.png"

cd "$SCRIPT_DIR"

./manuscript.sh

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

BODY_MD="${TMP_DIR}/body.md"
HEADER_TEX="${TMP_DIR}/header.tex"
BEFORE_BODY_TEX="${TMP_DIR}/before-body.tex"

tail -n +5 "$MANUSCRIPT_MD" > "$BODY_MD"

cat > "$HEADER_TEX" <<'EOF'
\usepackage[top=0.9in,bottom=1.15in,left=0.95in,right=0.95in,headheight=16pt,headsep=20pt,footskip=32pt]{geometry}
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage{mathpazo}
\usepackage{microtype}
\usepackage{graphicx}
\usepackage{xcolor}
\usepackage{fancyhdr}
\usepackage{parskip}
\usepackage{afterpage}

\setlength{\parindent}{1.2em}
\setlength{\parskip}{0.35em}
\linespread{1.05}
\raggedbottom

\definecolor{bedlamink}{HTML}{1D2430}
\definecolor{bedlamrule}{HTML}{C8CDD6}

\makeatletter
\renewcommand\section{\@startsection{section}{1}{\z@}%
  {0pt}%
  {0.6\baselineskip}%
  {\normalfont\Large\bfseries\color{bedlamink}}}
\makeatother

\renewcommand{\familydefault}{\rmdefault}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[C]{\small\itshape\color{bedlamink}\nouppercase{\leftmark}}
\fancyfoot[C]{\small\color{bedlamink}\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}
\renewcommand{\headrule}{\hbox to\headwidth{\color{bedlamrule}\leaders\hrule height \headrulewidth\hfill}}
\renewcommand{\sectionmark}[1]{\markboth{#1}{}}
\fancypagestyle{plain}{
  \fancyhf{}
  \fancyhead[C]{\small\itshape\color{bedlamink}\nouppercase{\leftmark}}
  \fancyfoot[C]{\small\color{bedlamink}\thepage}
  \renewcommand{\headrulewidth}{0.4pt}
  \renewcommand{\footrulewidth}{0pt}
}
EOF

cat > "$BEFORE_BODY_TEX" <<'EOF'
\begin{titlepage}
\thispagestyle{empty}
\newgeometry{margin=0pt}
\noindent\includegraphics[width=\paperwidth,height=\paperheight]{cover.png}
\restoregeometry
\end{titlepage}

\setcounter{page}{1}
\newgeometry{top=0.72in,bottom=0.82in,left=0.95in,right=0.95in,headheight=16pt,headsep=18pt,footskip=28pt}
\pagestyle{fancy}
\afterpage{\restoregeometry}
EOF

pandoc "$BODY_MD" \
  --from markdown \
  --standalone \
  --pdf-engine=pdflatex \
  --variable documentclass=extarticle \
  --variable fontsize=14pt \
  --shift-heading-level-by=-1 \
  --include-in-header="$HEADER_TEX" \
  --include-before-body="$BEFORE_BODY_TEX" \
  --resource-path="$SCRIPT_DIR" \
  --output "$OUTPUT_PDF"