% myresume.cls
% A LaTeX class for building resumes
% Optimized version (2026/02/20)

\ProvidesClass{myresume}[2026/02/20 Optimized resume class]

%-------------------------------------------------------------------------------
%                Class options
%-------------------------------------------------------------------------------
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

%-------------------------------------------------------------------------------
%                3rd party packages
%-------------------------------------------------------------------------------
\RequirePackage{array}
\RequirePackage{enumitem}
\RequirePackage{ragged2e}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{xcolor}
\RequirePackage{xifthen}
\RequirePackage{etoolbox}
\RequirePackage{setspace}
\RequirePackage{parskip}
\RequirePackage{fontspec}
\defaultfontfeatures{Ligatures=TeX}
\RequirePackage{unicode-math}
\RequirePackage{fontawesome}
\RequirePackage[skins]{tcolorbox}
\RequirePackage[hidelinks,unicode]{hyperref}

%-------------------------------------------------------------------------------
%                Page layout
%-------------------------------------------------------------------------------
\fancyhfoffset{0em}
\renewcommand{\headrulewidth}{0pt}
\fancyhf{}
\pagestyle{fancy}

%-------------------------------------------------------------------------------
%                Color definitions
%-------------------------------------------------------------------------------
\definecolor{darkgray}{HTML}{333333}
\definecolor{gray}{HTML}{5D5D5D}
\definecolor{lightgray}{HTML}{999999}
\definecolor{darktext}{HTML}{414141}

\colorlet{text}{darkgray}
\colorlet{graytext}{gray}
\colorlet{lighttext}{lightgray}

% Colorscheme
\definecolor{scheme-red}{HTML}{DC3522}
\definecolor{scheme-orange}{HTML}{FF6138}
\colorlet{colorscheme}{scheme-red}

%-------------------------------------------------------------------------------
%                Font configuration
%-------------------------------------------------------------------------------
\newfontfamily\cvfont[
  Path = fonts/,
  UprightFont = MapleMonoNL-NFMono-CN-Regular.ttf,
  BoldFont    = MapleMonoNL-NFMono-CN-Regular.ttf,
  ItalicFont  = MapleMonoNL-NFMono-CN-Regular.ttf,
  BoldItalicFont = MapleMonoNL-NFMono-CN-Regular.ttf,
  FakeBold    = 2.5,
]{}

%-------------------------------------------------------------------------------
%                Text styles
%-------------------------------------------------------------------------------
\newcommand*{\headernamestyle}[1]{{\fontsize{28pt}{1em}\cvfont\bfseries\color{text}#1}}
\newcommand*{\headerpositionstyle}[1]{{\fontsize{9pt}{1em}\cvfont\color{colorscheme}#1}}
\newcommand*{\headeraddressstyle}[1]{{\fontsize{9pt}{1em}\cvfont\itshape\color{lighttext}#1}}
\newcommand*{\headersocialstyle}[1]{{\fontsize{8pt}{1em}\cvfont\color{text}#1}}

\newcommand*{\sectionstyle}[1]{{\fontsize{14pt}{1em}\cvfont\bfseries\color{colorscheme}#1}}

\newcommand*{\entrytitlestyle}[1]{{\fontsize{11pt}{1em}\cvfont\bfseries\color{darktext}#1}}
\newcommand*{\entrypositionstyle}[1]{{\fontsize{9pt}{1em}\cvfont\color{graytext}#1}}
\newcommand*{\entrydatestyle}[1]{{\fontsize{9pt}{1em}\cvfont\slshape\color{graytext}#1}}
\newcommand*{\entrylocationstyle}[1]{{\fontsize{10pt}{1em}\cvfont\slshape\color{colorscheme}#1}}
\newcommand*{\descriptionstyle}[1]{{\fontsize{10pt}{1em}\cvfont\upshape\color{text}#1}}

%-------------------------------------------------------------------------------
%                Personal data commands
%-------------------------------------------------------------------------------
\newcommand*{\name}[1]{\def\@res@name{#1}}
\newcommand*{\position}[1]{\def\@res@position{#1}}
\newcommand*{\address}[1]{\def\@res@address{#1}}
\newcommand*{\mobile}[1]{\def\@res@mobile{#1}}
\newcommand*{\email}[1]{\def\@res@email{#1}}
\newcommand*{\github}[1]{\def\@res@github{#1}}
\newcommand*{\wechat}[1]{\def\@res@wechat{#1}}

% Photo command with options
% Syntax: \photo[<options>]{<image file>}
% Options: circle|rectangle, edge|noedge, left|right
\newcommand{\photo}[2][circle,edge,left]{%
  \def\@res@photo{#2}%
  % Default values
  \def\@res@photo@shape{circle}%
  \def\@res@photo@edge{edge}%
  \def\@res@photo@align{left}%
  % Parse options
  \@for\res@tmp:=#1\do{%
    \ifdefstring{\res@tmp}{circle}{\def\@res@photo@shape{circle}}{}%
    \ifdefstring{\res@tmp}{rectangle}{\def\@res@photo@shape{rectangle}}{}%
    \ifdefstring{\res@tmp}{edge}{\def\@res@photo@edge{edge}}{}%
    \ifdefstring{\res@tmp}{noedge}{\def\@res@photo@edge{noedge}}{}%
    \ifdefstring{\res@tmp}{left}{\def\@res@photo@align{left}}{}%
    \ifdefstring{\res@tmp}{right}{\def\@res@photo@align{right}}{}%
  }%
}

%-------------------------------------------------------------------------------
%                Utility macros
%-------------------------------------------------------------------------------
\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}

% Horizontal rule fill (used in section headings)
\def\res@hrulefill#1{\leavevmode\leaders\hrule\@height#1\hfill\kern\z@}

%-------------------------------------------------------------------------------
%                CV structure commands (spacing parameters)
%-------------------------------------------------------------------------------
\newcommand{\res@header@after@name@skip}{.4mm}
\newcommand{\res@header@after@position@skip}{.4mm}
\newcommand{\res@header@after@address@skip}{-.5mm}
\newcommand{\res@header@icon@sep}{\space}
\newcommand{\res@header@social@sep}{\quad\textbar\quad}
\newcommand{\res@header@after@social@skip}{6mm}
\newcommand{\res@section@top@skip}{3mm}
\newcommand{\res@section@content@top@skip}{2.5mm}

% Social items helper
\newif\if@res@social@first
\newcommand{\res@socialitem}[3][]{%
  \ifblank{#2}{}{%
    \if@res@social@first\@res@social@firstfalse\else\res@header@social@sep\fi
    \ifstrempty{#1}{\href{#2}{#3}}{\href{#1}{#3}}%
  }%
}

% Photo dimensions (calculated once)
\newlength{\res@photo@diameter}
\newlength{\res@header@text@width}
\newlength{\res@header@photo@width}

% Generate CV header
% Optional argument: alignment (L, R, or C) for text
\newcommand*{\makecvheader}[1][C]{%
  \ifdefined\@res@photo
    % Set photo diameter based on shape
    \ifdefstring{\@res@photo@shape}{circle}%
      {\setlength{\res@photo@diameter}{1.3cm}}%
      {\setlength{\res@photo@diameter}{1.8cm}}%
    % Set border color
    \ifdefstring{\@res@photo@edge}{edge}%
      {\def\res@photo@border{darkgray}}%
      {\def\res@photo@border{none}}%
    % Command to draw photo
    \def\res@drawphoto{%
      \begin{tikzpicture}%
        \node[\@res@photo@shape, draw=\res@photo@border, line width=0.3mm,
              inner sep=\res@photo@diameter, fill overzoom image=\@res@photo] () {};
      \end{tikzpicture}%
    }%
  \fi
  % Calculate widths
  \ifdefined\@res@photo
    \setlength{\res@header@text@width}{0.76\textwidth}%
    \setlength{\res@header@photo@width}{0.24\textwidth}%
  \else
    \setlength{\res@header@text@width}{\textwidth}%
    \setlength{\res@header@photo@width}{0pt}%
  \fi
  % Left photo column
  \begin{minipage}[c]{\res@header@photo@width}%
    \ifdefstring{\@res@photo@align}{left}{\raggedright\res@drawphoto}{}%
  \end{minipage}%
  % Text column
  \begin{minipage}[c]{\res@header@text@width}%
    \ifstrequal{#1}{L}{\raggedright}{%
      \ifstrequal{#1}{R}{\raggedleft}{\centering}%
    }%
    \headernamestyle{\@res@name}%
    \\[\res@header@after@name@skip]%
    \ifdefined\@res@position\headerpositionstyle{\@res@position}\\[\res@header@after@position@skip]\fi
    \ifdefined\@res@address\headeraddressstyle{\@res@address}\\[\res@header@after@address@skip]\fi
    \headersocialstyle{%
      \@res@social@firsttrue
      \ifdefined\@res@mobile \res@socialitem{}{\faMobile\res@header@icon@sep\@res@mobile} \fi
      \ifdefined\@res@email \res@socialitem{mailto:\@res@email}{\faEnvelope\res@header@icon@sep\@res@email} \fi
      \ifdefined\@res@github \res@socialitem{https://github.com/\@res@github}{\faGithubSquare\res@header@icon@sep\@res@github} \fi
      \ifdefined\@res@wechat \res@socialitem{}{\faWeixin\res@header@icon@sep\@res@wechat} \fi
    }\\[\res@header@after@social@skip]%
  \end{minipage}%
  % Right photo column
  \begin{minipage}[c]{\res@header@photo@width}%
    \ifdefstring{\@res@photo@align}{right}{\raggedleft\res@drawphoto}{}%
  \end{minipage}%
}

% Section heading
\newcommand{\cvsection}[1]{%
  \vspace{\res@section@top@skip}%
  \sectionstyle{#1}%
  \phantomsection
  {\color{gray}\res@hrulefill{1.1pt}}%
}

% Entry list environment
\newenvironment{cventries}{%
  \vspace{\res@section@content@top@skip}%
  \begin{center}%
}{%
  \end{center}%
}

% Single entry
% Arguments: position, title, location, date, description
\newcommand*{\cventry}[5]{%
  \vspace{-2.0mm}%
  \setlength\tabcolsep{0pt}%
  \setlength{\extrarowheight}{0pt}%
  \begin{tabular*}{\textwidth}{@{\extracolsep{\fill}} L{\textwidth-4.5cm} R{4.5cm}}%
    \ifblank{#2#3}{%
      \entrypositionstyle{#1} & \entrydatestyle{#4} \\%
    }{%
      \entrytitlestyle{#2} & \entrylocationstyle{#3} \\%
      \entrypositionstyle{#1} & \entrydatestyle{#4} \\%
    }%
    \multicolumn{2}{L{\textwidth}}{\descriptionstyle{#5}}%
  \end{tabular*}%
}

% Itemized list inside entries
\newenvironment{cvitems}{%
  \vspace{-3.0mm}%
  \begin{justify}%
    \begin{itemize}[leftmargin=4ex, nosep, noitemsep]%
      \setlength{\parskip}{5pt}%
      \renewcommand{\labelitemi}{\bullet}%
}{%
    \end{itemize}%
  \end{justify}%
  \vspace{-2.0mm}%
}%
