# expects package_id

set book_no [db_string random { 
    select book_no, random() as seed 
    from   bookshelf_books 
    where  package_id = :package_id 
    and    publish_status = 'publish' 
    order  by seed
    limit  1
} -default {}]

if { ![empty_string_p $book_no] } {
    bookshelf::book::get -package_id $package_id -book_no $book_no -array book

    set book(url) [export_vars -base "[site_node::get_url_from_object_id -object_id $package_id]book-view" { book_no }]

    set book(image_url) [bookshelf::amazon::get_image_url $book(isbn)]

    bookshelf::amazon::get_image_info -array amazon_info $book(isbn)
    set book(image_width) $amazon_info(image_width)
    set book(image_height) $amazon_info(image_height)
}

