# Include template
#
# Lists the books in this package

# Expects:
#   package_id:optional

# optional: limit (sets a limit to how many are shown)

if { ![exists_and_not_null package_id] } {
    set package_id [ad_conn package_id]
}

if { [exists_and_not_null limit] } {
    set limit_clause "limit $limit"
} else {
    set limit_clause ""
}

db_multirow -extend { view_url main_entry_html } book books "
    select b.book_id,
           b.book_no,
           b.isbn,
           b.book_author,
           b.book_title,
           b.main_entry,
           b.main_entry_mime_type,
           b.additional_entry,
           b.excerpt,
           b.publish_status,
           b.read_status,
           bookshelf_book__read_status_pretty(b.read_status) as read_status_pretty,
           o.creation_user,
           o.creation_date,
           to_char(o.creation_date, 'fmMonth DDfm, YYYY') as creation_date_pretty,
           u.first_names as creation_user_first_names,
           u.last_name as creation_user_last_name
    from   bookshelf_books b join 
           acs_objects o on (o.object_id = b.book_id) join
           persons u on (u.person_id = o.creation_user)
    where  package_id = :package_id
    and    publish_status = 'publish'
    order  by bookshelf_book__read_status_sort_order(b.read_status) desc, o.creation_date desc
    $limit_clause
" {
    if { [empty_string_p $excerpt] } {
        set excerpt [string_truncate -len 300 -- $main_entry]
    }
    set read_status_pretty [string totitle $read_status_pretty]
    set view_url "book-view?[export_vars { book_no }]"

    set richtext [list $main_entry $main_entry_mime_type]
    set main_entry_html [template::util::richtext::get_property html_value $richtext]
}

