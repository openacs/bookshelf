ad_page_contract {
    Add or edit a book.

    @creation-date 2002-09-08
    @author Lars Pind (lars@pinds.com)
    @cvs-id $Id$
} {
    book_no:integer,optional
} -properties {
    page_title
    context
    image_url
    book_url
}

set package_id [ad_conn package_id]

if { [info exists book_no] } {
    db_1row book_id {
        select book_id
        from   bookshelf_books
        where  book_no = :book_no
        and    package_id = :package_id
    }
    set page_title "Edit book"
} else {
    set page_title "Add book"
    set image_url ""
}

set context [list $page_title]

if { ![ad_form_new_p -key book_no] } {
    set delete_url [export_vars -base book-delete { book_no }]
}

ad_form -name book -form {
    book_id:key(acs_object_id_seq)
    {isbn:text {label "ISBN"} {after_html {(<a href="javascript:isbn_update();">update info from Amazon.com</a>)}}}
    {__isbn_update_flag:integer(hidden) {value 0}}
    {book_author:text {label "Author"} {html { size 50 }} optional }
    {book_title:text {label "Title"} {html { size 50 }} }
    {main_entry:richtext(richtext) {label "Main entry"} {html { rows 10 cols 60 }} optional }
    {additional_entry:richtext(richtext) {label "Additional entry"} {html { rows 10 cols 60 }} optional }
    {publish_status:text(select) {label "Publish status"} {options { { "Draft" draft } { "Publish" publish } } } }
    {read_status:text(select) {label "Read status"} {options { { "In the queue" queue } { "In hand" hand } { "On shelf" shelf } } } }
} -edit_request {
    bookshelf::book::get -book_id $book_id -array book

    foreach var { book_id isbn book_author book_title publish_status read_status } {
        set $var $book($var)
    }
    
    set main_entry [template::util::richtext::create $book(main_entry) $book(main_entry_mime_type)]
    set additional_entry [template::util::richtext::create $book(additional_entry) $book(additional_entry_mime_type)]

    
} -new_data {
    bookshelf::book::new \
        -book_id $book_id \
        -isbn $isbn \
        -book_author $book_author \
        -book_title $book_title \
        -main_entry [template::util::richtext::get_property text $main_entry] \
        -main_entry_mime_type [template::util::richtext::get_property mime_type $main_entry] \
        -additional_entry [template::util::richtext::get_property text $additional_entry] \
        -additional_entry_mime_type [template::util::richtext::get_property mime_type $additional_entry] \
        -publish_status $publish_status \
        -read_status $read_status

    ad_returnredirect -message "Your review of \"$book_title\" has been created." "."
    return
} -edit_data {
    bookshelf::book::edit \
        -book_id $book_id \
        -isbn $isbn \
        -book_author $book_author \
        -book_title $book_title \
        -main_entry [template::util::richtext::get_property text $main_entry] \
        -main_entry_mime_type [template::util::richtext::get_property mime_type $main_entry] \
        -additional_entry [template::util::richtext::get_property text $additional_entry] \
        -additional_entry_mime_type [template::util::richtext::get_property mime_type $additional_entry] \
        -publish_status $publish_status \
        -read_status $read_status

    ad_returnredirect -message "Your review of \"$book_title\" has been modified." "."
    return
} -on_submit {
    set isbn [string trim $isbn]
}


form get_values book isbn __isbn_update_flag
set isbn [string trim $isbn]
if { $__isbn_update_flag && [exists_and_not_null isbn] } {
    set image_url [bookshelf::amazon::get_image_url $isbn]
    set book_url [bookshelf::amazon::get_book_url $isbn]
    
    bookshelf::amazon::get_book_info -array amazon_book_info $isbn
    element set_value book book_author $amazon_book_info(book_author)
    element set_value book book_title $amazon_book_info(book_title)
}

