# Expects:
#   book:onerow

set package_id [ad_conn package_id]
set write_p [ad_permission_p $package_id write]
set book_no $book(book_no)

if { ![empty_string_p $book(isbn)] } {

    set book(url) [bookshelf::amazon::get_book_url $book(isbn)]

    set book(image_url) [bookshelf::amazon::get_image_url $book(isbn)]

    bookshelf::amazon::get_image_info -array amazon_info $book(isbn)

    set book(image_width) $amazon_info(image_width)
    set book(image_height) $amazon_info(image_height)
} else {
    set book(url) {}
    set book(image_url) {}
    set book(image_width) {}
    set book(image_height) {}
}

set perma_url "book-view?[export_vars { book_no }]"

if { $write_p } {
    set edit_url "book-edit?[export_vars { book_no }]"
    if { [string equal $book(publish_status) "draft"] } {
        set publish_url "book-publish?[export_vars { book_no }]"
    } else {
        set draft_url "book-publish?[export_vars { book_no { publish_status "draft"} }]"
    }
}
