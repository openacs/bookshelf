ad_page_contract {
    Publish or unpublish a book.

    @creation-date 2002-09-29
    @author Lars Pind (lars@pinds.com)
    @cvs-id $Id$
} {
    book_no:integer
    {publish_status "publish"}
    {return_url {book-view?[export_vars { book_no  }]}}
} -validate {
    publish_status_allowed -requires { publish_status } {
        if { ![string equal $publish_status "publish"] && ![string equal $publish_status "draft"] } {
            ad_complain "Publish status must be 'publish' or 'draft'"
        }
    }
}

set package_id [ad_conn package_id]

set found_p [db_0or1row book_id {
    select book_id
    from   bookshelf_books
    where  book_no = :book_no
    and    package_id = :package_id
}]

if { !$found_p } { 
    ad_return_error "Bad book no" "Can't find any book with this book number."
    ad_script_abort
}

bookshelf::book::publish \
        -book_id $book_id \
        -publish_status $publish_status

ad_returnredirect $return_url
