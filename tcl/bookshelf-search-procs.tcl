ad_library {
    Bookshelf - Search Service Contracts

    @creation-date 2004-04-20
    @author Jeff Davis davis@xarg.net
    @cvs-id $Id$
}

namespace eval bookshelf::book::search {}

ad_proc -private bookshelf::book::search::datasource { book_id } {
    returns a datasource for the search package this is the content 
    that will be indexed by the full text search engine.

    @param book_id

    @author Jeff Davis davis@xarg.net
} {
    if {[db_0or1row get {select package_id, book_no from bookshelf_books where book_id = :book_id}]} {
        set base [apm_package_url_from_id $package_id]
    } else { 
        set base {}
    }
    set full "[ad_url]$base"

    bookshelf::book::get -book_id $book_id -array book
    set title "$book(book_title) by $book(book_author)"

    set body [template::adp_include /packages/bookshelf/lib/one-book [list & "book" base $base style feed]]

    return [list object_id $book_id \
                title $title \
                content $body \
                keywords {} \
                storage_type text \
                mime text/html \
                syndication [list link ${full}book-view?book_no=$book(book_no) \
                                 description "Book review" \
                                 guid "[ad_url]/o/$book_id" \
                                 category {book review} \
                                 pubDate $book(creation_date) \
                                 author "$book(creation_user_first_names) $book(creation_user_last_name)" ] \
               ]
}

ad_proc -private bookshelf::book::search::url { book_id } {
    returns a url for a given book_id

    @param book_id
    @author Jeff Davis davis@xarg.net
} {
    if {[db_0or1row get {select package_id, book_no from bookshelf_books where book_id = :book_id}]} {
        return "[ad_url][apm_package_url_from_id $package_id]book-view?book_no=$book_no"
    } else {
        error "book_id $book_id not found"
    }
}



ad_proc -private bookshelf::book::search::register_implementations {} {
    register the search impl for bookshelf 
} {
    db_transaction {
        bookshelf::book::search::register_fts_impl
    }
}

ad_proc -private bookshelf::book::search::unregister_implementations {} {
    db_transaction { 
        acs_sc::impl::delete -contract_name FtsContentProvider -impl_name bookshelf_book
    }
}

ad_proc -private bookshelf::book::search::register_fts_impl {} {
    set spec {
        name "bookshelf_book"
        aliases {
            datasource bookshelf::book::search::datasource
            url bookshelf::book::search::url
        }
        contract_name FtsContentProvider
        owner bookshelf
    }

    acs_sc::impl::new_from_spec -spec $spec
}



