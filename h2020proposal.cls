% h2020proposal.cls
%
% LaTeX class for writing EU H2020 RIA proposals.
%
% Adapted from ICTProposal.cls 2010/08/09 version V0.9 by Giacomo Indiveri
% Based on the 2009 fet-workpackage.sty file by Dennis Goehlsdorf and
% the 2008 ProposalB-template.tex files by Elisabetta Chicca and Chiara
% Bartolozzi. Major extensions by Lars Eggert.
%
% Copyright (c) 2010, Giacomo Indiveri
% Copyright (c) 2017, Lars Eggert
%
% This latex class is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% h2020proposal.cls is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with h2020proposal.  If not, see <http://www.gnu.org/licenses/>.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{h2020proposal}[2017/09/01 revision V1.0 by Giacomo Indiveri and Lars Eggert]
\ClassInfo{h2020proposal}{-- See the h2020proposal manual for usage information.}
\ClassInfo{h2020proposal}{-- The source comments also have basic usage notes.}

% define new needed flags to indicate document options
% and set a few "failsafe" defaults
\newif\if@draftmode       \global\@draftmodefalse

\DeclareOption{draft}{
  \global\@draftmodetrue%
  \PassOptionsToPackage{draft}{memoir}%
  \PassOptionsToPackage{final}{graphicx}
}
\ExecuteOptions{a4paper}
\ProcessOptions


% We use the memoir class because it offers a many easy to use features.
\if@draftmode%
  \typeout{** ATTENTION: DRAFT mode.}%
  \LoadClass[article,a4paper,draft,showtrims,11pt,oneside]{memoir}%
  \usepackage[notref,notcite]{showkeys}
  \usepackage[final]{rotating}
  \renewcommand{\showkeyslabelformat}[1]{\begin{sideways} \framebox{\normalfont\tiny\ttfamily\color{red}#1} \end{sideways}}
\else
  \LoadClass[article,a4paper,11pt,oneside]{memoir}%
\fi%

\setmarginnotes{17pt}{51pt}{\onelineskip}
\settrimmedsize{297mm}{210mm}{*}
\setlength{\trimtop}{0pt}
\setlength{\trimedge}{\stockwidth}
\addtolength{\trimedge}{-\paperwidth}
\settypeblocksize{693pt}{490pt}{*}
\setulmargins{2.75cm}{*}{*}
\setlrmargins{1.75cm}{*}{*}
\setheadfoot{\onelineskip}{2\onelineskip}
\setheaderspaces{*}{2\onelineskip}{*}
\checkandfixthelayout

\usepackage{coolstr}   % for string checking
\usepackage{mdframed}
\usepackage[normalem]{ulem}
% \usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{newtxtext}
\usepackage[hypertexnames=false, bookmarks=false, hidelinks]{hyperref}
\usepackage{multirow}
\usepackage{enumitem}
\usepackage{siunitx}
\usepackage{ltablex}
\usepackage{makecell}
\usepackage[usenames, dvipsnames, table]{xcolor}
\usepackage{pgfgantt}
\usepackage{eurosym}
\usepackage{morewrites}
\usepackage[width=\textwidth]{caption}

\usetikzlibrary{calc, fit}

\sisetup{group-minimum-digits=4, detect-all=true, binary-units, free-standing-units, range-units=single, per-mode=symbol}

\keepXColumns
\setlength\tabcolsep{3pt} % default value: 6pt

\renewcommand{\arraystretch}{1.1}

\mdfsetup{
  % linecolor=gray,
  innerleftmargin=6pt,
  innerrightmargin=6pt,
  innertopmargin=6pt,
  innerbottommargin=9pt,
  skipabove=3pt,
  skipbelow=3pt
}

% \arrayrulecolor{gray}

\setlist{topsep=0pt, itemsep=3pt, parsep=3pt}

\def\maxwidth#1{\ifdim\Gin@nat@width>#1 #1\else\Gin@nat@width\fi}

\newcommand{\instructions}[1]{
  \if@draftmode%
  {\color{blue}{#1}}
  \fi%
}

\newcommand{\todo}[1]{{\colorbox{red!30}{#1}}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Proposal pagestyle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set page heading and footers. Read memman Chap.7 for more info on
% customized headers and footers

% Page Footers
\makeevenfoot{plain}{\@shortname}{}{\thepage}
\makeoddfoot{plain}{\@shortname}{}{\thepage}

% Page Headers
\makeoddhead{plain}{}{}{}
\makeevenhead{plain}{}{}{}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Proposal Information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcounter{@wpcount} % Main Work package counter
\newcounter{@milestone} % Milestones counter
\newcounter{@risk} % Critical risk counter
\newcounter{@pcount} % Participant counter
\newcounter{@totpm} % Total project person months counter
\newcounter{@totdeliv} % Total deliverables counter
\newcounter{@tottask} % Total tasks counter

% Assign values to global variables
\newcommand{\shortname}[1]{%
  \gdef\@shortname{#1}%
  \gdef\acronym{#1}%
}%
\newcommand{\titlelogo}[2]{
  \gdef\@titlelogoname{#1}
  \gdef\@titlelogoscale{#2}
}%
\newcommand{\duration}[1]{
  \newcounter{@duration}%
  \setcounter{@duration}{#1}%
}%
\newcommand{\participant}[5]{%
  \stepcounter{@pcount}% Participants counter
  \newcounter{@p\arabic{@pcount}totpm} % Total participants person months counter
  \newcounter{@p#2num}%
  \setcounter{@p#2num}{\value{@pcount}}%
  \expandafter\xdef\csname @pFullName\arabic{@p#2num}\endcsname{#1}%
  \expandafter\xdef\csname @pShortName\arabic{@p#2num}\endcsname{#2}%
  \expandafter\xdef\csname @pCountry\arabic{@p#2num}\endcsname{#3}%
  \expandafter\xdef\csname @pLogo\arabic{@p#2num}\endcsname{#4}%
  \expandafter\xdef\csname @pDesc\arabic{@p#2num}\endcsname{#5}%
}%
% Display variables assigned
\newcommand{\disptoken}[1]{%
  \csname#1\endcsname
}%
% Get participant number from short name
\newcommand{\getPnum}[1]{%
  \@ifundefined{c@@p#1num}{}{\arabic{@p#1num}}%
}%
%  Create participants table row
\newcommand{\ptablerow}[1]{%
  \stepcounter{#1}%
  \the\value{#1}%
  \ifthenelse{\value{#1}=1}{ (Coordinator) &}{&}%
  \disptoken{@pFullName\arabic{#1}} &
  \disptoken{@pShortName\arabic{#1}} &
  \disptoken{@pCountry\arabic{#1}} \\
  \hline%
}%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Proposal Title Page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Redefine \maketitle
\renewcommand\maketitle{\par
  \begingroup
%  \let\clearpage\relax
  \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
  \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
  \long\def\@makefntext##1{\parindent 1em\noindent
    \hb@xt@1.8em{%
      \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
  \newpage
  \global\@topnum\z@   % Prevents figures from going at top of page
  \@maketitle
  \thispagestyle{empty}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}

\def\@maketitle{%
  \null
  \begin{center}%
    \let \footnote \thanks
    {\huge \bfseries \@title \par \vspace{1em}}
    {\LARGE \bfseries \@shortname \par \vspace{1em}}
    \ifx\@titlelogoname\empty \else
    \includegraphics[scale=\@titlelogoscale]{\@titlelogoname}
    \fi
    \par
  \end{center}
}%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Participants Table
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\makeparticipantstable} {%
  % set counters, and decrease count by one to get tabular to work properly
  \newcounter{@ptable}
  \newcounter{@pcountminusone}
  \setcounter{@pcountminusone}{\value{@pcount}}
  \addtocounter{@pcountminusone}{-1}
  % create Participants table
  \begin{tabularx}{\textwidth}{|l|X|c|c|}
    \hline
    \textbf{\makecell[l]{Participant\\number}} &
    \textbf{Participant organisation name} &
    \textbf{\makecell[c]{Short\\name}} &
    \textbf{Country} \\
    \hline
    \whiledo{\value{@ptable}<\value{@pcountminusone}}{\ptablerow{@ptable}}%
    \ptablerow{@ptable} % add last row by hand to get tabularx to
    % work properly
  \end{tabularx}
  \vspace{8em}
}%


\newcommand{\makeparticipantsdesc} {%
  \newcounter{@pdesc}
  \whiledo{\value{@pdesc}<\value{@pcount}}{
    \stepcounter{@pdesc}%
    \ifthenelse{\value{@pdesc}>1}{\clearpage}{}%
    \subsection{\disptoken{@pFullName\arabic{@pdesc}}}%
    \setlength\tabcolsep{6pt}
    % \renewcommand{\arraystretch}{1.1}
    \begin{tabularx}{\textwidth}{|l|Xc|}
      \hline
      \textbf{Participant number} & \the\value{@pdesc} \ifthenelse{\value{@pdesc}=1}{ (Coordinator)}{} & \multirow{4}{*}{\ifthenelse{\equal{\disptoken{@pLogo\arabic{@pdesc}}}{}}{\todo{LOGO MISSING}}{\raisebox{-.5\height}{\includegraphics[keepaspectratio, height=5em, width=\maxwidth{5cm}]{\disptoken{@pLogo\arabic{@pdesc}}}}}} \\
      \textbf{Organisation name} & \disptoken{@pFullName\arabic{@pdesc}} & \\
      \textbf{Short name} & \disptoken{@pShortName\arabic{@pdesc}} & \\
      \textbf{Country} & \disptoken{@pCountry\arabic{@pdesc}} & \\
      \hline
    \end{tabularx}%
    \setlength\tabcolsep{3pt}
    % \renewcommand{\arraystretch}{1}
    \begin{mdframed}%
    \vspace{-1em}%
    \ifthenelse{\equal{\disptoken{@pDesc\arabic{@pdesc}}}{}}{\todo{DESCRIPTION MISSING}}{\input{\disptoken{@pDesc\arabic{@pdesc}}}}
    \end{mdframed}%
  }%
}%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Work package macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcounter{@wptask}
\newcounter{@wpdeliv}
\newcounter{@wpgroup}
\newcounter{@wpcolempty}
\newcounter{@wpcolgroup}
\newcounter{@wpcolidx}
\newcounter{@wpcountgroups}
\newcounter{@wptotgroups}
\newcounter{@pmpnum}

% \renewcommand{\the@wpcount}{WP.\arabic{@wpcount}}
\renewcommand{\the@wptask}{T\the@wpcount.\arabic{@wptask}}
\renewcommand{\the@wpdeliv}{D\the@wpcount.\arabic{@wpdeliv}}

\newcommand{\wptitle}[1]{%
\expandafter\xdef\csname @wp\arabic{@wpcount}Title\endcsname{#1}
}%
\newcommand{\wpstart}[1]{%
\expandafter\xdef\csname @wp\arabic{@wpcount}StartMonth\endcsname{#1}
}%
\newcommand{\wpend}[1]{%
\expandafter\xdef\csname @wp\arabic{@wpcount}EndMonth\endcsname{#1}
}%
\newcommand{\wptype}[1]{%
\expandafter\xdef\csname @wp\arabic{@wpcount}Type\endcsname{#1}
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Work package environment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{workpackage}[2]%
{%
  \refstepcounter{@wpcount}

  \newcounter{@wp\arabic{@wpcount}totpm}
  \newcounter{@wp\arabic{@wpcount}tottk}
  \setcounter{@wptask}{0}
  \setcounter{@wpdeliv}{0}
  \setcounter{@wpgroup}{0}
  \setcounter{@wptotgroups}{0}

  \clearpage
  \ifthenelse{\equal{#2}{}}{}{\label{#2}}%
  \subsection{Work Package \arabic{@wpcount}: #1}
  \wptitle{#1}%
  \noindent

  % WP objectives environment
  \newenvironment{wpobjectives}{%
    \begin{mdframed}%
      \vspace{-1em}
      \subsubsection*{Objectives}
    }{%
    \end{mdframed}
  }%

  % WP description environment
  \newenvironment{wpdescription}{%
    \begin{mdframed}%
      \vspace{-1em}
      \subsubsection*{Description of work}
      \vspace{-1em}
    }{%
    \end{mdframed}
  }%

  % WP description environment
  \newenvironment{wpdeliverables}{%
    \begin{mdframed}%
      \vspace{-1em}
      \subsubsection*{Deliverables}
      \vspace{-1em}
    }{%
    \end{mdframed}
  }%
}{%
  \ignorespacesafterend
}%

\newcommand{\wptask}[7]
{% leader, contributors, start, end, title, label, description
  \refstepcounter{@wptask}
  \stepcounter{@tottask}
  \stepcounter{@wp\arabic{@wpcount}tottk}
  % Linear vector for task list index entries
  \newcounter{@tk\arabic{@tottask}WP}
  \setcounter{@tk\arabic{@tottask}WP}{\value{@wpcount}}
  \newcounter{@tk\arabic{@tottask}T}
  \setcounter{@tk\arabic{@tottask}T}{\value{@wptask}}
  % Strings
  \expandafter\xdef\csname
  @wp\arabic{@wpcount}Task\arabic{@wptask}Leader\endcsname{\getPnum{#1}}
  \expandafter\xdef\csname
  @wp\arabic{@wpcount}Task\arabic{@wptask}PI\endcsname{#1}
  \expandafter\xdef\csname
  @wp\arabic{@wpcount}Task\arabic{@wptask}Contributors\endcsname{#2}
  \expandafter\xdef\csname
  @wp\arabic{@wpcount}Task\arabic{@wptask}Start\endcsname{#3}
  \expandafter\xdef\csname
  @wp\arabic{@wpcount}Task\arabic{@wptask}End\endcsname{#4}
  \expandafter\xdef\csname
  @wp\arabic{@wpcount}Task\arabic{@wptask}Title\endcsname{#5}
  \vspace{1em}
  \textbf{\uline{Task \the@wptask:  #5  \hfill \hfill (%
  \ifthenelse{\equal{#3}{0}}{\todo{M#3}}{M#3}--%
  \ifthenelse{\equal{#4}{0}}{\todo{M#4}}{M#4}%
  )}}  \\
  \textit{Leader: #1}
  \ifthenelse{\equal{#2}{}}{}{\textit{\\Contributors: #2}}
  \ifthenelse{\equal{#6}{}}{}{\label{#6}}

  #7
}%

\newcommand{\wpdeliverable}[6][12]
{ % [delivery date]{leader}{nature}{dissemination level}{title}{label}
  % if no delivery date is specified, the default is M12
  \refstepcounter{@wpdeliv}
  \stepcounter{@totdeliv}
  % Linear vector for sorting dates in delivery list table, and index entries
  \newcounter{@deliv\arabic{@totdeliv}date}
  \setcounter{@deliv\arabic{@totdeliv}date}{#1}
  \newcounter{@deliv\arabic{@totdeliv}WP}
  \setcounter{@deliv\arabic{@totdeliv}WP}{\value{@wpcount}}
  \newcounter{@deliv\arabic{@totdeliv}N}
  \setcounter{@deliv\arabic{@totdeliv}N}{\value{@wpdeliv}}
  \newcounter{@deliv\arabic{@totdeliv}D}
  \setcounter{@deliv\arabic{@totdeliv}D}{\value{@wpdeliv}}
  % Strings
  \expandafter\xdef\csname
  @wp\arabic{@wpcount}Deliv\arabic{@wpdeliv}DeliveryDate\endcsname{#1}
  \expandafter\xdef\csname
  @wp\arabic{@wpcount}Deliv\arabic{@wpdeliv}Leader\endcsname{#2}
  \expandafter\xdef\csname
  @wp\arabic{@wpcount}Deliv\arabic{@wpdeliv}Nature\endcsname{#3}
  \expandafter\xdef\csname
  @wp\arabic{@wpcount}Deliv\arabic{@wpdeliv}DLevel\endcsname{#4}
  \expandafter\xdef\csname
  @wp\arabic{@wpcount}Deliv\arabic{@wpdeliv}Title\endcsname{#5}
  % Output
  \vspace{1em}
  \textbf{\uline{Deliverable {\the@wpdeliv}: #5 \hfill \hfill (%
  \ifthenelse{\equal{#1}{0}}{\todo{M#1}}{M#1}%
  )}} \\
  \textit{Leader: #2}\ifthenelse{\equal{#6}{}}{}{\label{#6}}
  }%

\newcommand{\personmonths}{\@ifnextchar{*}{\@leaderpersonmonths}{\@personmonths}}
\def\@leaderpersonmonths*#1#2{%
  \stepcounter{@wptotgroups}
  \addtocounter{@wp\arabic{@wpcount}totpm}{#2}
  \setcounter{@pmpnum}{\getPnum{#1}}
  \expandafter\xdef\csname @wpLeader\arabic{@wpcount}\endcsname{\getPnum{#1}}
  \addtocounter{@p\arabic{@pmpnum}totpm}{#2}
  \expandafter\xdef\csname
  @pmParticipant\arabic{@pmpnum}WP\arabic{@wpcount}\endcsname{#2}
  \expandafter\xdef\csname
  @pmLeader\arabic{@pmpnum}WP\arabic{@wpcount}\endcsname{#2}
}%

\newcommand{\@personmonths}[2]{%
  \stepcounter{@wptotgroups}
  \addtocounter{@wp\arabic{@wpcount}totpm}{#2}
  \setcounter{@pmpnum}{\getPnum{#1}}
  \addtocounter{@p\arabic{@pmpnum}totpm}{#2}
  \expandafter\xdef\csname
  @pmParticipant\arabic{@pmpnum}WP\arabic{@wpcount}\endcsname{#2}
}%

% WP Table row
\newcounter{@wppart}
\newcounter{@wpactpart}%

\newcommand{\wptablerow}[1]{%
  \setcounter{@wppart}{0}%
  \whiledo{\value{@wppart}<\value{@pcount}}{%
    \stepcounter{@wppart}%
    \@ifundefined{@pmLeader\arabic{@wppart}WP\arabic{@wpcount}}{%
      \@ifundefined{@pmParticipant\arabic{@wppart}WP\arabic{@wpcount}}{}{& #1}%
    }{& \textbf{#1}}%
  }%
  \\
  \hline
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WP Table
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\makewptable} {%
  \setlength\tabcolsep{6pt}%
  % \renewcommand{\arraystretch}{1.1}
  \setcounter{@wpactpart}{0}%
  \setcounter{@wppart}{0}%
  \whiledo{\value{@wppart}<\value{@pcount}}{%
    \stepcounter{@wppart}%
    \@ifundefined{@pmLeader\arabic{@wppart}WP\arabic{@wpcount}}{%
      \@ifundefined{@pmParticipant\arabic{@wppart}WP\arabic{@wpcount}}{}{\stepcounter{@wpactpart}}%
    }{\stepcounter{@wpactpart}}%
  }%
  \ifthenelse{\value{@wpactpart}<3}{\setcounter{@wpactpart}{3}}{}%
  \begin{tabularx}{\textwidth}{|p{10em}|*{\value{@wpactpart}}{>{\centering\arraybackslash}X|}}

  \hline
  \textbf{Work package number} &
  \multicolumn{1}{l|}{WP\the@wpcount} &
  \multicolumn{\the\numexpr\value{@wpactpart}-2\relax}{r|}{\textbf{Lead beneficiary}} &
  \multicolumn{1}{l|}{\disptoken{@wpLeader\arabic{@wpcount}} (\csname @pShortName\csname @wpLeader\arabic{@wpcount}\endcsname\endcsname) } \\
  \hline

  \textbf{Work package title} &
  \multicolumn{\value{@wpactpart}}{>{\hsize=\dimexpr\value{@wpactpart}\hsize+\value{@wpactpart}\tabcolsep+\arrayrulewidth\relax}X|}{\textbf{\disptoken{@wp\arabic{@wpcount}Title}}} \\
  \hline

  \textbf{Participant number}
  \wptablerow{\arabic{@wppart}}

  \textbf{Short name}
  \wptablerow{\disptoken{@pShortName\arabic{@wppart}}}

  \textbf{Person months}
  \wptablerow{\disptoken{@pmParticipant\arabic{@wppart}WP\arabic{@wpcount}}}

  \textbf{Start month} &
  \multicolumn{1}{l|}{M\disptoken{@wp\arabic{@wpcount}StartMonth}} &
  \multicolumn{\the\numexpr\value{@wpactpart}-2\relax}{r|}{\textbf{End month}} &
  \multicolumn{1}{l|}{M\disptoken{@wp\arabic{@wpcount}EndMonth}} \\
  \hline
  \end{tabularx}%
  \addtocounter{@totpm}{\value{@wp\arabic{@wpcount}totpm}}%
  \setlength\tabcolsep{3pt}%
  % \renewcommand{\arraystretch}{1}
}%


% Direct Costs Macros

\newcounter{@costsT}  % Travel costs counter
\newcounter{@costsE}  % Equipment costs counter
\newcounter{@costsC}  % Consumables costs counter
\newcounter{@costsO}  % Other costs counter
\newcounter{@totcosts} % Total costs counter

\newcommand{\costsTravel}[3]{%
  % {participant}{cost}{justification}
  \setcounter{@costsT}{\getPnum{#1}}%
  \newcounter{@dctpnum\arabic{@costsT}}
  \addtocounter{@dctpnum\arabic{@costsT}}{#2}
  \expandafter\protected@xdef\csname @tJustification\arabic{@costsT}\endcsname{\detokenize{#3}}%
}

\newcommand{\costsEquipment}[3]{
  % {participant}{cost}{justification}
  \setcounter{@costsE}{\getPnum{#1}}%
  \newcounter{@dcepnum\arabic{@costsE}}
  \setcounter{@dcepnum\arabic{@costsE}}{#2}
  \expandafter\protected@xdef\csname @eJustification\arabic{@costsE}\endcsname{\detokenize{#3}}%
}

\newcommand{\costsConsumables}[3]{%
  % {participant}{cost}{justification}
  \setcounter{@costsC}{\getPnum{#1}}%
  \newcounter{@dccpnum\arabic{@costsC}}
  \setcounter{@dccpnum\arabic{@costsC}}{#2}
  \expandafter\protected@xdef\csname @cJustification\arabic{@costsC}\endcsname{\detokenize{#3}}%
}

\newcommand{\costsOther}[3]{%
  % {participant}{cost}{justification}
  \setcounter{@costsO}{\getPnum{#1}}%
  \newcounter{@dcopnum\arabic{@costsO}}
  \setcounter{@dcopnum\arabic{@costsO}}{#2}
  \expandafter\protected@xdef\csname @oJustification\arabic{@costsO}\endcsname{\detokenize{#3}}%
}

% Other direct costs Table

\newcommand{\makecoststable} {%
  \InputIfFileExists{\jobname.lco}{}{
    \ClassWarning{h2020proposal}{\ClassWarning{h2020proposal}{No
      participants defined yet. Use the \texttt{\textbackslash
        participant} command to define new participants.}}%
}}%

\newcommand{\writecolist} {%
  \newboolean{@dctdefined}
  \newboolean{@dcedefined}
  \newboolean{@dccdefined}
  \newboolean{@dcodefined}
  \setcounter{@row}{0}
  \newwrite\colistfile
  \immediate\openout\colistfile=\jobname.lco
  \immediate\write\colistfile{\noexpand\begin{tabularx}{\textwidth}{|p{10em}|r|X|}}
  \whiledo{\value{@row}<\value{@pcount}}{%
    \stepcounter{@row}
    \setcounter{@totcosts}{0}
    \@ifundefined{c@@dctpnum\arabic{@row}}{%
      \setboolean{@dctdefined}{false}}{%
      \setboolean{@dctdefined}{true}}
    \@ifundefined{c@@dcepnum\arabic{@row}}{%
      \setboolean{@dcedefined}{false}}{%
      \setboolean{@dcedefined}{true}}
    \@ifundefined{c@@dccpnum\arabic{@row}}{%
    	\setboolean{@dccdefined}{false}}{%
      \setboolean{@dccdefined}{true}}
    \@ifundefined{c@@dcopnum\arabic{@row}}{%
      \setboolean{@dcodefined}{false}}{%
      \setboolean{@dcodefined}{true}}
    \ifthenelse{
      \boolean{@dctdefined}
      \OR
      \boolean{@dcedefined}
      \OR
    	\boolean{@dccdefined}
    	\OR
      \boolean{@dcodefined}
    }{%
      \immediate\write\colistfile{%
        \noexpand\hline
        \noexpand\textbf{Participant \arabic{@row}}
        \noexpand\textbf{(\csname @pShortName\arabic{@row}\endcsname)} &
        \noexpand\textbf{Cost (\noexpand\euro)} &
        \noexpand\textbf{Justification}
        \noexpand\\
        \noexpand\hline}
      \ifthenelse{\boolean{@dctdefined}}{%
        \addtocounter{@totcosts}{\value{@dctpnum\arabic{@row}}}
        \immediate\write\colistfile{%
          \noexpand\textbf{Travel} &
          \noexpand\num{\arabic{@dctpnum\arabic{@row}}} &
          \csname @tJustification\arabic{@row}\endcsname
          \noexpand\\\noexpand\hline}
      }{}%
      \ifthenelse{\boolean{@dcedefined}}{%
        \addtocounter{@totcosts}{\value{@dcepnum\arabic{@row}}}
        \immediate\write\colistfile{%
          \noexpand\textbf{Equipment} &
          \noexpand\num{\arabic{@dcepnum\arabic{@row}}} &
          \csname @eJustification\arabic{@row}\endcsname
          \noexpand\\\noexpand\hline}
      }{}%
  	  \ifthenelse{\boolean{@dccdefined}}{%
  	    \addtocounter{@totcosts}{\value{@dccpnum\arabic{@row}}}
  	    \immediate\write\colistfile{%
  	      \noexpand\textbf{Consumables} &
  	      \noexpand\num{\arabic{@dccpnum\arabic{@row}}} &
  	      \csname @cJustification\arabic{@row}\endcsname
  	      \noexpand\\\noexpand\hline}
  	  }{}%
      \ifthenelse{\boolean{@dcodefined}}{%
        \addtocounter{@totcosts}{\value{@dcopnum\arabic{@row}}}
        \immediate\write\colistfile{%
          \noexpand\textbf{Other goods \& services} &
          \noexpand\num{\arabic{@dcopnum\arabic{@row}}} &
          \csname @oJustification\arabic{@row}\endcsname
          \noexpand\\\noexpand\hline}
      }{}%
      \immediate\write\colistfile{%
          \noexpand\textbf{Total} &
          {\noexpand\num{\arabic{@totcosts}}} &
          \noexpand\\\noexpand\hline
      }
      \ifthenelse{\value{@row}<\value{@pcount}}{
        \immediate\write\colistfile{\noexpand\multicolumn{3}{c}{}\noexpand\\}
      }{}%
    }{}%
  }%
  \immediate\write\colistfile{%
    \noexpand\caption{`Other direct cost' items (travel, equipment, consumables, other goods and services).}
    \noexpand\label{tab:3.4b}
    \noexpand\end{tabularx}
  }
}%


% Large Research Infrastructure tables
\newcounter{@costsLRI}  % Other costs counter

\newcommand{\costslri}[3]{%
  % {participant}{cost}{justification}
  \setcounter{@costsLRI}{\getPnum{#1}}%
  \newcounter{@lripnum\arabic{@costsLRI}}
  \addtocounter{@lripnum\arabic{@costsLRI}}{#2}
  \expandafter\protected@xdef\csname @lriJustification\arabic{@costsLRI}\endcsname{#3}%
}

\newboolean{@lridefined}

\newcommand{\makelritable} {%
  \InputIfFileExists{\jobname.lri}{}{
    \ClassWarning{h2020proposal}{\ClassWarning{h2020proposal}{No
      participants defined yet. Use the \texttt{\textbackslash
        participant} command to define new participants.}}%
}}%


\newcommand{\writelrilist} {%
  \setcounter{@row}{0}
  \newwrite\lrilistfile
  \immediate\openout\lrilistfile=\jobname.lri
  \ifthenelse{\value{@pcount}<1}{}{
    \immediate\write\lrilistfile{\noexpand\begin{tabularx}{\textwidth}{|p{13em}|r|X|}}
    \whiledo{\value{@row}<\value{@pcount}}{%
      \stepcounter{@row}
      \@ifundefined{c@@lripnum\arabic{@row}}{}{%
        \ifthenelse{\value{@row}>1}{%
          \immediate\write\lrilistfile{\noexpand\multicolumn{3}{c}{}\noexpand\\}
        }{}
        \immediate\write\lrilistfile{%
          \noexpand\hline
          \noexpand\textbf{Participant \arabic{@row}}
          \noexpand\textbf{(\csname @pShortName\arabic{@row}\endcsname)} & \noexpand\textbf{Cost (\noexpand\euro)} & \noexpand\textbf{Justification}\noexpand\\
          \noexpand\hline
          \noexpand\textbf{Large research infrastructure} & \noexpand\num{\arabic{@lripnum\arabic{@row}}} & \csname @lriJustification\arabic{@row}\endcsname\noexpand\\
          \noexpand\hline
        }%
      }%
    }%
    \immediate\write\lrilistfile{%
      \noexpand\caption{`Other direct cost' items (large research infrastructure).} \noexpand\label{tab:3.4c}
      \noexpand\end{tabularx}
    }
  }%
}%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make list commands that use auxiliary files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\counterwithin{table}{section}

% redefining this counter does not work here, because it gets
% redefined at every chapter. It is important to add this command at
% the beginning of Section 1.3
\renewcommand{\thetable}{\thesection\alph{table}}
\stepcounter{table}

\newcounter{@row}

% WP List
\newcommand{\makewplist} {%
  \setcounter{table}{1} % this is table 3.1b
  \InputIfFileExists{\jobname.lwp}{}{
    \ClassWarning{h2020proposal}{Work Package List data not complete
      yet. Recompile to include all data.}}%
}%


\newcommand{\writewplist}{
  % create wplist table on auxiliary lwp file
  \setcounter{@row}{0}
  \newwrite\wplistfile
  \immediate\openout\wplistfile=\jobname.lwp
  \immediate\write\wplistfile{%
    \noexpand\begin{tabularx}{\textwidth}{|c|X|c|c|r|c|c|}
    }%
    \immediate\write\wplistfile{\noexpand\hline}
    \immediate\write\wplistfile{%
      {\noexpand\textbf{\noexpand\makecell[c]{Work\noexpand\\package}}} &
      {\noexpand\textbf{WP title}} &
      {\noexpand\textbf{\noexpand\makecell[c]{Lead\noexpand\\participant}}} &
      {\noexpand\textbf{\noexpand\makecell[c]{Short\noexpand\\name}}} &
      {\noexpand\textbf{\noexpand\makecell[c]{Person\noexpand\\months}}} &
      {\noexpand\textbf{\noexpand\makecell[c]{Start\noexpand\\month}}} &
      {\noexpand\textbf{\noexpand\makecell[c]{End\noexpand\\month}}}
      \noexpand\\
    }%
    \immediate\write\wplistfile{\noexpand\hline}%
    \ifthenelse{\value{@wpcount}<1}{\ClassWarning{h2020proposal}{Work packages
        not defined yet. Use the \texttt{\textbackslash workpackage}
          environment to define new work packages.}}{%
      \whiledo{\value{@row}<\value{@wpcount}}{%
        \stepcounter{@row}
        \immediate\write\wplistfile{%
          \noexpand\textbf{WP\arabic{@row}} &
          \csname @wp\arabic{@row}Title\endcsname &
          \csname @wpLeader\arabic{@row}\endcsname &
          \csname @pShortName\csname @wpLeader\arabic{@row}\endcsname\endcsname &
          \arabic{@wp\arabic{@row}totpm} &
          M\csname @wp\arabic{@row}StartMonth\endcsname &
          M\csname @wp\arabic{@row}EndMonth\endcsname
          \noexpand\\}%
        \immediate\write\wplistfile{\noexpand\hline}
      }%
    }%
    \immediate\write\wplistfile{%
      \noexpand\multicolumn{4}{|r|}{\noexpand\textbf{Total person months}} &
      \noexpand{\arabic{@totpm}} &
      \noexpand\multicolumn{2}{c|}{}
      \noexpand\\
      \noexpand\hline
    }%
    \immediate\write\wplistfile{\noexpand\caption{List of work packages.} \noexpand\label{tab:3.1b}}
    \immediate\write\wplistfile{\noexpand\end{tabularx}}%
  \closeout\wplistfile
}%

% Deliverables List
\newcommand{\makedeliverablelist} {%
  \InputIfFileExists{\jobname.ldl}{}{
    \ClassWarning{h2020proposal}{Deliverable List data not complete
      yet. Recompile to include all data.}}%
}%


% Sorting pseudo code Insertion sort
%     while i< length[A] do
%         i++
%         value := A[i];
%         j := i - 1;
%         done := false;
%         repeat
%             if A[j] > value then
%             begin
%                 A[j + 1] := A[j];
%                 j := j - 1;
%                 if j < 0 then
%                     done := true;
%             end
%             else
%                 done := true;
%         until done;
%         A[j + 1] := value;
%     end;
\newcounter{@deliv0date}
\setcounter{@deliv0date}{0}
\newboolean{@done}
\newcommand{\delivsort}{%
  \newcounter{@tmpdate}
  \newcounter{@tmpWP}
  \newcounter{@tmpN}
  \newcounter{@tmpD}
  \newcounter{@posi}
  \newcounter{@posj}
  \newcounter{@posjup}
  \setcounter{@posi}{1}
  \whiledo{\value{@posi}<\value{@totdeliv}}{%
    \stepcounter{@posi}
    \setcounter{@tmpdate}{\value{@deliv\arabic{@posi}date}}
    \setcounter{@tmpWP}{\value{@deliv\arabic{@posi}WP}}
    \setcounter{@tmpN}{\value{@deliv\arabic{@posi}N}}
    \setcounter{@tmpD}{\value{@deliv\arabic{@posi}D}}
    \setcounter{@posj}{\value{@posi}}
    \addtocounter{@posj}{-1}
    \setboolean{@done}{false}
    \whiledo{\NOT \boolean{@done}}{%
      \ifthenelse{\value{@deliv\arabic{@posj}date}>\value{@tmpdate}}{%
        \setcounter{@posjup}{\value{@posj}}
        \stepcounter{@posjup}
        % Swap j <-> j+1
        \setcounter{@deliv\arabic{@posjup}date}{\value{@deliv\arabic{@posj}date}}
        \setcounter{@deliv\arabic{@posjup}WP}{\value{@deliv\arabic{@posj}WP}}
        \setcounter{@deliv\arabic{@posjup}N}{\value{@deliv\arabic{@posj}N}}
        \setcounter{@deliv\arabic{@posjup}D}{\value{@deliv\arabic{@posj}D}}
        \addtocounter{@posj}{-1}
        \ifthenelse{\value{@posj}<0}{\setboolean{@done}{true}}{}
      }{%
        \setboolean{@done}{true}
      }%
      \setcounter{@posjup}{\value{@posj}}
      \stepcounter{@posjup}
      \setcounter{@deliv\arabic{@posjup}date}{\value{@tmpdate}}
      \setcounter{@deliv\arabic{@posjup}WP}{\value{@tmpWP}}
      \setcounter{@deliv\arabic{@posjup}N}{\value{@tmpN}}
      \setcounter{@deliv\arabic{@posjup}D}{\value{@tmpD}}
    }%
  }%
}%

\newcommand{\writedelivlist}{
  % create delivlist table on auxiliary ldl file
  \setcounter{@row}{0}
  \newwrite\delivlistfile
  \immediate\openout\delivlistfile=\jobname.ldl
  \immediate\write\delivlistfile{%
    \noexpand\begin{tabularx}{\textwidth}{|c|X|c|c|c|c|c|}
    }%
    \immediate\write\delivlistfile{\noexpand\hline}
    \immediate\write\delivlistfile{%
      {\noexpand\textbf{\noexpand\makecell[c]{Deliverable\noexpand\\number}}} &
      {\noexpand\textbf{Deliver\-able name}} &
      {\noexpand\textbf{\noexpand\makecell[c]{Work\noexpand\\package}}} &
      {\noexpand\textbf{\noexpand\makecell[c]{Lead\noexpand\\partici-\noexpand\\pant}}} &
      {\noexpand\textbf{Type}} &
      {\noexpand\textbf{\noexpand\makecell[c]{Dissemi-\noexpand\\nation\noexpand\\level}}} &
      {\noexpand\textbf{\noexpand\makecell[c]{Delivery\noexpand\\date}}}
      \noexpand\\
    }%
    \immediate\write\delivlistfile{\noexpand\hline}%
    \ifthenelse{\value{@totdeliv}<1}{\ClassWarning{h2020proposal}{Deliverables
        not defined yet. Use the \texttt{\textbackslash deliverable}
          command to define new deliverables.}}{%
      \delivsort
      \whiledo{\value{@row}<\value{@totdeliv}}{%
        \stepcounter{@row}
        \immediate\write\delivlistfile{%
          \noexpand\textbf{D\arabic{@deliv\arabic{@row}WP}.\arabic{@deliv\arabic{@row}D}} &
          \csname
          @wp\arabic{@deliv\arabic{@row}WP}Deliv\arabic{@deliv\arabic{@row}D}Title\endcsname &
          WP\arabic{@deliv\arabic{@row}WP} &
          \csname
          @wp\arabic{@deliv\arabic{@row}WP}Deliv\arabic{@deliv\arabic{@row}D}Leader\endcsname &
          \csname
          @wp\arabic{@deliv\arabic{@row}WP}Deliv\arabic{@deliv\arabic{@row}N}Nature\endcsname &
          \csname
          @wp\arabic{@deliv\arabic{@row}WP}Deliv\arabic{@deliv\arabic{@row}D}DLevel\endcsname &
          M\arabic{@deliv\arabic{@row}date}
          \noexpand\\}%
        \immediate\write\delivlistfile{\noexpand\hline}
      }%
    }%
    \immediate\write\delivlistfile{\noexpand\caption{List of deliverables.} \noexpand\label{tab:3.1c}}
    \immediate\write\delivlistfile{\noexpand\end{tabularx}}%
  \closeout\delivlistfile
}%

% Proposal Milestones Macro
\newcommand{\milestone}[4][12]{%
  % [due date]{title}{means of verification}{wps involved}
  \refstepcounter{@milestone}
  \expandafter\protected@xdef\csname @ms\arabic{@milestone}Date\endcsname{#1}%
  \expandafter\protected@xdef\csname @ms\arabic{@milestone}Title\endcsname{#2}%
  \expandafter\protected@xdef\csname @ms\arabic{@milestone}Verification\endcsname{#3}%
  \expandafter\protected@xdef\csname @ms\arabic{@milestone}WPList\endcsname{#4}%
}%

% Milestones List
\newcommand{\makemilestoneslist} {%
  \InputIfFileExists{\jobname.lms}{}{
    \ClassWarning{h2020proposal}{Milestone List data not complete
      yet. Recompile to include all data.}}%
}%


% Milestones Table
\newcommand{\writemslist}{
  % create wplist table on auxiliary lwp file
  \setcounter{@row}{0}
  \newwrite\mslistfile
  \immediate\openout\mslistfile=\jobname.lms
  \immediate\write\mslistfile{%
    \noexpand\begin{tabularx}{\textwidth}{|c|p{10em}|c|c|X|}
    }%
    \immediate\write\mslistfile{\noexpand\hline}
    \immediate\write\mslistfile{%
      {\noexpand\textbf{\noexpand\makecell[c]{Mile-\noexpand\\stone\noexpand\\number}}} &
      {\noexpand\textbf{Milestone name}} &
      {\noexpand\textbf{\noexpand\makecell[c]{Re-\noexpand\\lated\noexpand\\WPs}}} &
      {\noexpand\textbf{\noexpand\makecell[c]{Esti-\noexpand\\mated\noexpand\\date}}} &
      {\noexpand\textbf{Means of verification}}
      \noexpand\\
    }%
    \immediate\write\mslistfile{\noexpand\hline}%
    \ifthenelse{\value{@milestone}<1}{\ClassWarning{h2020proposal}{Milestones
        not defined yet. Use the \texttt{\textbackslash milestone}
          command to define new milestones.}}{%
      \whiledo{\value{@row}<\value{@milestone}}{%
        \stepcounter{@row}
        \immediate\write\mslistfile{%
          \noexpand\textbf{M\arabic{@row}} &
          \noexpand\csname @ms\arabic{@row}Title\endcsname &
          \noexpand\csname @ms\arabic{@row}WPList\endcsname &
          M\csname @ms\arabic{@row}Date\endcsname &
          \noexpand\csname @ms\arabic{@row}Verification\endcsname
          \noexpand\\
        }%
        \immediate\write\mslistfile{\noexpand\hline}
      }%
    }%
    \immediate\write\mslistfile{\noexpand\caption{List of milestones.} \noexpand\label{tab:3.2a}}
    \immediate\write\mslistfile{\noexpand\end{tabularx}}%
  \closeout\mslistfile
}%


% Proposal Critical Risks Macros
\newcommand{\criticalrisk}[5]{%
  % {description of risk}{wps involved}{probability}{importance}{risk-mitigation measures}
  \refstepcounter{@risk}
  \expandafter\protected@xdef\csname @rk\arabic{@risk}Description\endcsname{#1}%
  \expandafter\protected@xdef\csname @rk\arabic{@risk}WP\endcsname{#2}%
  \expandafter\protected@xdef\csname @rk\arabic{@risk}Probability\endcsname{#3}%
  \expandafter\protected@xdef\csname @rk\arabic{@risk}Importance\endcsname{#4}%
  \expandafter\protected@xdef\csname @rk\arabic{@risk}Solution\endcsname{#5}%
}%

% Risks List
\newcommand{\makerisklist} {%
  \InputIfFileExists{\jobname.lrk}{}{
    \ClassWarning{h2020proposal}{Risks List data not complete
      yet. Recompile to include all data.}}%
}%

\newcommand{\writerklist}{
  % create rklist table on auxiliary lrk file
  \setcounter{@row}{0} \newwrite\rklistfile
  \immediate\openout\rklistfile=\jobname.lrk
  \immediate\write\rklistfile{%
    \noexpand\begin{tabularx}{\textwidth}{|p{8em}|c|c|c|X|}
    }%
    \immediate\write\rklistfile{\noexpand\hline}
    \immediate\write\rklistfile{%
      {\noexpand\textbf{\noexpand\makecell[c]{Description\noexpand\\of risk}}} &
      {\noexpand\textbf{\noexpand\makecell[c]{WPs\noexpand\\involved}}} &
      {\noexpand\textbf{\noexpand\makecell[c]{Proba-\noexpand\\bility}}} &
      {\noexpand\textbf{\noexpand\makecell[c]{Impor-\noexpand\\tance}}} &
      {\noexpand\textbf{Proposed risk-mitigation measures}}\noexpand\\
    }%
    \immediate\write\rklistfile{\noexpand\hline}%
    \ifthenelse{\value{@risk}<1}{\ClassWarning{h2020proposal}{Risk
        not defined yet. Use the \texttt{\textbackslash criticalrisk}
        command within the Work Package Deliverables environment to
        define new tasks.}}{%
      \whiledo{\value{@row}<\value{@risk}}{%
        \stepcounter{@row}
        \immediate\write\rklistfile{%
          \csname @rk\arabic{@row}Description\endcsname &%
          \noexpand\csname @rk\arabic{@row}WP\endcsname &%
          \noexpand\csname @rk\arabic{@row}Probability\endcsname &%
          \noexpand\csname @rk\arabic{@row}Importance\endcsname &%
          \noexpand\csname @rk\arabic{@row}Solution\endcsname%
          \noexpand\\}%
        \immediate\write\rklistfile{\noexpand\hline}
      }%
    }%
  \immediate\write\rklistfile{\noexpand\caption{Critical risks for implementation.} \noexpand\label{tab:3.2b}}
  \immediate\write\rklistfile{\noexpand\end{tabularx}}%
  \closeout\rklistfile
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Summary of effort Table
\newcommand{\makesummaryofefforttable} {%
  \InputIfFileExists{\jobname.lse}{}{
    \ClassWarning{h2020proposal}{Summary of Effort List data not complete
      yet. Recompile to include all data.}}%
}%



\newcommand{\writesoelist}{
  % create wplist table on auxiliary lse file
  \newwrite\soelistfile \immediate\openout\soelistfile=\jobname.lse
  \immediate\write\soelistfile{%
    % \noexpand\stepcounter{table} % increase table counter, because WP tables are not real tables
      \noexpand\begin{tabularx}{\textwidth}{|c|X|r|r|r|r|r|r|r|}
      }%
      \immediate\write\soelistfile{\noexpand\hline}
      \immediate\write\soelistfile{%
        {\noexpand\textbf{\noexpand\makecell[c]{Participant\noexpand\\number}}} &
        {\noexpand\textbf{\noexpand\makecell[l]{Participant short name}}} }%
      \setcounter{@wpcolgroup}{0} \setcounter{@wpcolempty}{0}
      \whiledo{\value{@wpcolgroup}<7}{%
        \stepcounter{@wpcolgroup} \ifthenelse{\NOT
          \value{@wpcolgroup}>\value{@wpcount}} {
          \immediate\write\soelistfile{%
            & {\noexpand\textbf{WP\arabic{@wpcolgroup}}} }%
        }%
        {\stepcounter{@wpcolempty}\null} }% end whiledo
      \ifthenelse{\value{@wpcolempty}>0}%
      {%
        \immediate\write\soelistfile{%
          & \noexpand\multicolumn{\arabic{@wpcolempty}}{c|}{
            {\noexpand\textbf{\noexpand\makecell[c]{Participant\noexpand\\total PMs}}} }%
          \noexpand\\
        }}{%
        \immediate\write\soelistfile{%
          & {\noexpand\textbf{Total person months}} \noexpand\\
        }%
      }%
      \immediate\write\soelistfile{ \noexpand\hline }%
      \setcounter{@row}{0}
      \ifthenelse{\value{@pcount}<1}{\ClassWarning{h2020proposal}{No
          participants defined yet. Use the \texttt{\textbackslash
            participant} command to define new participants.}}{%
        \whiledo{\value{@row}<\value{@pcount}}{%
          \stepcounter{@row} \immediate\write\soelistfile{%
            \arabic{@row} & \csname @pShortName\arabic{@row}\endcsname
          }%
          \setcounter{@wpcolgroup}{0}
          \whiledo{\value{@wpcolgroup}<\value{@wpcount}}{%
            \stepcounter{@wpcolgroup}
            \@ifundefined{@pmLeader\arabic{@row}WP\arabic{@wpcolgroup}}
            {%
              \@ifundefined{@pmParticipant\arabic{@row}WP\arabic{@wpcolgroup}}
              {%
                \immediate\write\soelistfile{& 0} }{%
                \immediate\write\soelistfile{%
                  & \csname
                  @pmParticipant\arabic{@row}WP\arabic{@wpcolgroup}\endcsname
                }%
              }}{ \immediate\write\soelistfile{%
                & \noexpand\textbf{\csname
                  @pmParticipant\arabic{@row}WP\arabic{@wpcolgroup}\endcsname}
              }}}%
          \ifthenelse{\value{@wpcolempty}>0}%
          {%
            \immediate\write\soelistfile{%
              & \noexpand\multicolumn{\arabic{@wpcolempty}}{r|}{
                \arabic{@p\arabic{@row}totpm} }%
              \noexpand\\
            }}{ \immediate\write\soelistfile{%
              & \arabic{@p\arabic{@row}totpm} \noexpand\\
            }%
          }%
          \immediate\write\soelistfile{\noexpand\hline}%
        }%
        \immediate\write\soelistfile{\noexpand\multicolumn{2}{|r|}{\noexpand\textbf{Total person months}}}%
        \setcounter{@wpcolgroup}{0}
        \whiledo{\value{@wpcolgroup}<\value{@wpcount}}{%
          \stepcounter{@wpcolgroup} \immediate\write\soelistfile{%
            & \arabic{@wp\arabic{@wpcolgroup}totpm} }}%
        \ifthenelse{\value{@wpcolempty}>0}%
        {%
          \immediate\write\soelistfile{%
            & \noexpand\multicolumn{\arabic{@wpcolempty}}{r|}{
              \arabic{@totpm}}
            \noexpand\\
          }}%
        { \immediate\write\soelistfile{%
            & \arabic{@totpm}
            \noexpand\\
          }}\immediate\write\soelistfile{\noexpand\hline}%
      }%
      \immediate\write\soelistfile{\noexpand\caption{Summary of staff effort.} \noexpand\label{tab:3.4a}}
      \immediate\write\soelistfile{\noexpand\end{tabularx}}%
  \closeout\soelistfile }%

% Task List
\newcommand{\maketasklist} {%
  \InputIfFileExists{\jobname.ltk}{}{%
    \ClassWarning{h2020proposal}{Task List data not complete
      yet. Recompile to include all data.}}%
}%

\newcommand{\writetklist}{
  % create tklist table on auxiliary lwp file
  \setcounter{@row}{0} \newwrite\tklistfile
  \immediate\openout\tklistfile=\jobname.ltk
  \immediate\write\tklistfile{%
    \noexpand\begin{tabularx}{\textwidth}{|c|c|c|c|X|}
    }%
    \immediate\write\tklistfile{\noexpand\hline}
    \immediate\write\tklistfile{%
      {\noexpand\textbf{Task}} & {\noexpand\textbf{Leader}} &
      {\noexpand\textbf{\noexpand\makecell[c]{Start\noexpand\\date}}} &
      {\noexpand\textbf{\noexpand\makecell[c]{End\noexpand\\date}}} &
      {\noexpand\textbf{Title}} \noexpand\\
    }%
    \immediate\write\tklistfile{\noexpand\hline}%
    \ifthenelse{\value{@tottask}<1}{\ClassWarning{h2020proposal}{Tasks
        not defined yet. Use the \texttt{\textbackslash wptask}
        command within the Work Package Deliverables environment to
        define new tasks.}}{%
      \whiledo{\value{@row}<\value{@tottask}}{%
        \stepcounter{@row}
        \immediate\write\tklistfile{%
          \noexpand\textbf{T\arabic{@tk\arabic{@row}WP}.\arabic{@tk\arabic{@row}T}} &
          \csname
          @wp\arabic{@tk\arabic{@row}WP}Task\arabic{@tk\arabic{@row}T}PI\endcsname &
          M\csname
          @wp\arabic{@tk\arabic{@row}WP}Task\arabic{@tk\arabic{@row}T}Start\endcsname &
          M\csname
          @wp\arabic{@tk\arabic{@row}WP}Task\arabic{@tk\arabic{@row}T}End\endcsname &
          \csname
          @wp\arabic{@tk\arabic{@row}WP}Task\arabic{@tk\arabic{@row}T}Title\endcsname
          \noexpand\\}%
        \immediate\write\tklistfile{\noexpand\hline}
      }%
    }%
    \immediate\write\tklistfile{\noexpand\caption{List of tasks.} \noexpand\label{tab:3.4a}}
    \immediate\write\tklistfile{\noexpand\end{tabularx}}%
  \closeout\tklistfile }%


% Gantt chart data
\newcommand{\ganttchartdata} {%
  \InputIfFileExists {\jobname.gnt}{}{%
    \ClassWarning{h2020proposal}{Gantt chart data data not complete
      yet. Recompile to include all data.}}%
}%

\newcommand{\writegntdata}{
  % create tklist table on auxiliary lwp file
  \setcounter{@wpcolgroup}{0} % use this counter for wps
  \newwrite\gntchartfile \immediate\openout\gntchartfile=\jobname.gnt
  \whiledo{\value{@wpcolgroup}<\value{@wpcount}}{%
    \stepcounter{@wpcolgroup}
    \immediate\write\gntchartfile{%
      \noexpand\ganttgroup{WP\arabic{@wpcolgroup}
      }{\csname @wp\arabic{@wpcolgroup}StartMonth\endcsname}{\csname @wp\arabic{@wpcolgroup}EndMonth\endcsname}
    }%
    \immediate\write\gntchartfile{%
      \noexpand\ganttgroup[inline]{\csname @wp\arabic{@wpcolgroup}Title\endcsname
      }{\csname @wp\arabic{@wpcolgroup}StartMonth\endcsname}{\csname @wp\arabic{@wpcolgroup}EndMonth\endcsname}
      \noexpand\\
    }%
    \setcounter{@row}{0}
    \whiledo{\value{@row}<\value{@totdeliv}}{%
      \stepcounter{@row}
      \ifthenelse{\value{@wpcolgroup}=\value{@deliv\arabic{@row}WP}}{
        \ifthenelse{\arabic{@deliv\arabic{@row}date}>18}{
          \immediate\write\gntchartfile{%
            \noexpand\ganttmilestone[inline, milestone inline label node/.append style={left}] {D\arabic{@deliv\arabic{@row}WP}.\arabic{@deliv\arabic{@row}D}}{\arabic{@deliv\arabic{@row}date}}
          }%
        }{%
          \immediate\write\gntchartfile{%
            \noexpand\ganttmilestone[inline, milestone inline label node/.append style={right}] {D\arabic{@deliv\arabic{@row}WP}.\arabic{@deliv\arabic{@row}D}}{\arabic{@deliv\arabic{@row}date}}
         }%
        }%
      }{}
    }%
    \immediate\write\gntchartfile{\noexpand\\}%
    \setcounter{@row}{0} % use this counter for wp tasks
    \whiledo{\value{@row}<\value{@wp\arabic{@wpcolgroup}tottk}}{%
      \stepcounter{@row}
      \immediate\write\gntchartfile{%
        \noexpand\ganttbar{T\arabic{@wpcolgroup}.\arabic{@row}}
          {%
          \csname
          @wp\arabic{@wpcolgroup}Task\arabic{@row}Start\endcsname}{%
          \csname
          @wp\arabic{@wpcolgroup}Task\arabic{@row}End\endcsname}
      }%
      \immediate\write\gntchartfile{%
        \noexpand\ganttbar[inline]{\csname @wp\arabic{@wpcolgroup}Task\arabic{@row}Title\endcsname}
          {%
          \csname
          @wp\arabic{@wpcolgroup}Task\arabic{@row}Start\endcsname}{%
          \csname
          @wp\arabic{@wpcolgroup}Task\arabic{@row}End\endcsname}
        \noexpand\\
      }%
    }%
    \ifthenelse{\value{@wpcolgroup}<\value{@wpcount}}{
      \immediate\write\gntchartfile{%
      \noexpand\ganttnewline
      }%
    }{}%
  }%
  \closeout\gntchartfile
}%


% Create auxiliary file with table data
\AtEndDocument{%
  \writewplist
  \writedelivlist
  \writemslist
  \writerklist
  \writesoelist
  \writetklist
  \writecolist
  \writelrilist
  \writegntdata
}%
