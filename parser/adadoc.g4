grammar adadoc;

adadoc
    : special+
    ;

special
    : '@' command
    ;

command
    : (source_command | global_property | html_property
    | rtf_property | other_command) WHITESPACE*
    ;

source_command
    : source | toc
    ;

global_property
    : hide_index_entries | show_index_entries
    | hide_annotations | show_annotations
    | hide_iso | show_iso
    | link_non_terminals
    | number_paragraphs
    | title
    | file_prefix
    | example_font
    | body_font
    | note_format
    | contents_format
    | list_format
    | subdivision_names
    ;

html_property
    : single_html_output_file
    | use_ms_dos_names
    | html_kind_command
    | html_nav_bar
    | html_tabs
    | html_script
    | html_header
    | html_footer
    | html_color
    | html_new_revision_colors
    ;

rtf_property
    : single_rtf_output_file
    | rtf_header_prefix
    | rtf_footer_text
    | rtf_footer
    | rtf_page_size
    | rtf_fonts
    | rtf_version_name
    ;

other_command
    : comment | unknown
    ;

source
    : 'Source' named_parameters
    ;

toc
    : 'TOC'
    ;

hide_index_entries
    : 'HideIndexEntries'
    ;

show_index_entries
    : 'ShowIndexEntries'
    ;

hide_annotations
    : 'HideAnnotations'
    ;

show_annotations
    : 'ShowAnnotations'
    ;

hide_iso
    : 'HideISO'
    ;

show_iso
    : 'ShowISO'
    ;

link_non_terminals
    : 'LinkNonTerminals'
    ;

number_paragraphs
    : 'NumberParagraphs'
    ;

title
    : 'Title' named_parameters
    ;

file_prefix
    : 'FilePrefix' text_parameter
    ;

example_font
    : 'ExampleFont' text_parameter
    ;

body_font
    : 'BodyFont' text_parameter
    ;

note_format
    : 'NoteFormat' text_parameter
    ;

contents_format
    : 'ContentsFormat' text_parameter
    ;

list_format
    : 'ListFormat' text_parameter
    ;

subdivision_names
    : 'SubdivisionNames' text_parameter
    ;

/* unused? */
single_html_output_file
    : 'SingleHTMLOutputFile'
    ;

/* unused? */
use_ms_dos_names
    : 'UseMSDOSNames'
    ;

html_kind_command
    : 'HTMLKind' named_parameters
    ;

html_nav_bar
    : 'HTMLNavBar' named_parameters
    ;

html_tabs
    : 'HTMLTabs' text_parameter
    ;

/* unused? */
html_script
    : 'HTMLScript' text_parameter
    ;

html_header
    : 'HTMLHeader' text_parameter
    ;

html_footer
    : 'HTMLFooter' text_parameter
    ;

html_color
    : 'HTMLColor' named_parameters
    ;

html_new_revision_colors
    : 'HTMLNewRevisionColors'
    ;

single_rtf_output_file
    : 'SingleRTFOutputFile'
    ;

rtf_header_prefix
    : 'RTFHeaderPrefix' named_parameters
    ;

rtf_footer_text
    : 'RTFFooterText' named_parameters
    ;

rtf_footer
    : 'RTFFooter' named_parameters
    ;

rtf_page_size
    : 'RTFPageSize' text_parameter
    ;

rtf_fonts
    : 'RTFFonts' named_parameters
    ;

rtf_version_name
    : 'RTFVersionName' named_parameters
    ;

comment
    : 'Comment' text_parameter
    ;

/* unused? */
unknown
    : comment
    ;

named_parameters
    : LEFT_BRACE named_parameter (',' named_parameter)* RIGHT_BRACE
    ;

named_parameter
    : LETTER+ '=' text_parameter
    ;

text_parameter
    : LEFT_BRACE text RIGHT_BRACE
    ;

text
    : (LETTER | DIGIT | SYMBOL | WHITESPACE | LEFT_BRACE | RIGHT_BRACE)+
    ;

LEFT_BRACE : '[' | '(' | '{' | '<' ;

RIGHT_BRACE : '>' | '}' | ')' | ']' ;

WHITESPACE : ' ' | '\t' | '\r' | '\n' ;

LETTER : 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G'
       | 'H' | 'I' | 'J' | 'K' | 'L' | 'M' | 'N'
       | 'O' | 'P' | 'Q' | 'R' | 'S' | 'T' | 'U'
       | 'V' | 'W' | 'X' | 'Y' | 'Z' | 'a' | 'b'
       | 'c' | 'd' | 'e' | 'f' | 'g' | 'h' | 'i'
       | 'j' | 'k' | 'l' | 'm' | 'n' | 'o' | 'p'
       | 'q' | 'r' | 's' | 't' | 'u' | 'v' | 'w'
       | 'x' | 'y' | 'z'
	   ;

DIGIT  : '0' | '1' | '2' | '3' | '4' | '5' | '6'
       | '7' | '8' | '9'
	   ;

SYMBOL : ':' | '|' | '.' | ',' | ';' | '/'
       | '-' | '%' | '&' | '#' | '"' | '\\' 
	   | '_' | '\'' | '@'
	   ;
