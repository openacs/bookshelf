# Include template
#
# Lists the book titles in this package

# Expects:
#   package_id:optional

if { ![exists_and_not_null package_id] } {
    set package_id [ad_conn package_id]
}

db_multirow -extend { view_url } book books {
    select b.book_id,
           b.book_no,
           b.isbn,
           b.book_author,
           b.book_title,
           b.main_entry,
           b.additional_entry,
           b.excerpt,
           b.publish_status,
           b.read_status,
           bookshelf_book__read_status_pretty(b.read_status) as read_status_pretty,
           o.creation_user,
           o.creation_date,
           u.first_names || ' ' || u.last_name as creation_user_name
    from   bookshelf_books b join 
           acs_objects o on (o.object_id = b.book_id) join
           cc_users u on (u.user_id = o.creation_user)
    where  b.package_id = :package_id
    and    publish_status = 'publish'
    order  by bookshelf_book__read_status_sort_order(b.read_status), o.creation_date desc
} {
    if { [empty_string_p $excerpt] } {
        set excerpt [string_truncate -len 300 -- $main_entry]
    }
    set read_status_pretty [string totitle $read_status_pretty]
    set view_url "book-view?[export_vars { book_no }]"
}

