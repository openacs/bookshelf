ad_page_contract {
    Delete bookreview
} {
    book_no:integer
    {return_url {[export_vars -base book-edit { book_no }]}}
    {done_url .}
    {confirmed_p:boolean 0}
}

set package_id [ad_conn package_id]

db_1row book {
    select book_id, 
           book_title, 
           book_author
    from   bookshelf_books
    where  book_no = :book_no
    and    package_id = :package_id
}

if { $confirmed_p } {
    bookshelf::book::delete -book_id $book_id
    ad_returnredirect -message "The book review for \"$book_title\" has been deleted." $done_url
}

set confirmed_url [export_vars -base [ad_conn url] { book_no return_url { confirmed_p 1 } }]

set page_title "Delete review of \"$book_title\""
set context [list [list [export_vars -base book-edit { book_no }] "Edit book"] "Delete book"]
