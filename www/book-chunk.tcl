# Expects:
#   book:onerow

set package_id [ad_conn package_id]
set write_p [ad_permission_p $package_id write]

set book(url) [bookshelf::amazon::get_book_url $book(isbn)]

set book(image_url) [bookshelf::amazon::get_image_url $book(isbn)]

bookshelf::amazon::get_image_info -array amazon_info $book(isbn)

set book(image_width) $amazon_info(image_width)
set book(image_height) $amazon_info(image_height)

set perma_url "[ad_url][ad_conn package_url]book-view?[export_vars { book_no }]"
set google_url "http://www.google.com/search?[export_vars { {q $book(book_title) } }]"

if { $write_p } {
    set edit_url "book-edit?[export_vars { {book_no $book(book_no)}}]"
    if { [string equal $book(publish_status) "draft"] } {
        set publish_url "book-publish?[export_vars { {book_no $book(book_no)} }]"
    } else {
        set draft_url "book-publish?[export_vars { {book_no $book(book_no)} { publish_status "draft"} }]"
    }
}
