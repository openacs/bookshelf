ad_page_contract {
    View a book.

    @creation-date 2002-09-08
    @author Lars Pind (lars@pinds.com)
    @cvs-id $Id$
} {
    book_no:integer
} -properties {
    page_title
    context_bar
    book
}

set package_id [ad_conn package_id]

set page_title "One Book"

set context_bar [ad_context_bar $page_title]

bookshelf::book::get -book_no $book_no -array book

