# Expects "title" and "header" and "context_bar" or "context"

if { ![info exists title] } {
    set title ""
} 

if { ![info exists header] } {
    set header $title
}

if { ![info exists context_bar] && ![info exists context] } {
    set context [list $header]
}

ad_return_template
