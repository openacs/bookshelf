ad_page_contract {
    Bookshelf: List books

    @creation-date 2002-09-08
    @author Lars Pind (lars@pinds.com)
    @cvs-id $Id$
} {
    creation_user:integer,optional
    read_status:optional
    publish_status:optional
}

set package_id [ad_conn package_id]
set write_p [ad_permission_p $package_id write]

if { !$write_p } {
    ad_return_template bookshelf
    return
}

set context_bar [ad_context_bar]

db_1row instance_name {
    select instance_name
    from   apm_packages
    where  package_id = :package_id
}

set page_title $instance_name

set human_readable_filter "All books"
set where_clauses [list "b.package_id = :package_id"]
set filters_p 0

if { [info exists read_status] } {
    lappend where_clauses "b.read_status = :read_status"
    db_1row read_status_pretty {
        select bookshelf_book__read_status_pretty(:read_status) as read_status_pretty
    }
    append human_readable_filter " $read_status_pretty"
    set filters_p 1
}

if { [info exists creation_user] } {
    lappend where_clauses "o.creation_user = :creation_user"
    if { $creation_user ==  [ad_conn user_id] } {
        append human_readable_filter " reviewed by me"
    } else {
        db_1row creation_user_name { 
            select first_names || ' ' || last_name as creation_user_name from cc_users where user_id = :creation_user 
        }
        append human_readable_filter " reviewed by $creation_user_name"
    }
    set filters_p 1
}

if { [info exists publish_status] } {
    lappend where_clauses "b.publish_status = :publish_status"
    if { [string equal $publish_status "draft"] } {
        append human_readable_filter " that are not yet published"
        set filters_p 1
    }
} elseif { !$write_p } {
    # if you don't have write permission, then we only show published books
    lappend where_clauses "b.publish_status = 'publish'"
}

if { $filters_p } {
    set clear_filters_url "."
} else {
    set clear_filters_url {}
}

set sql "
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
           to_char(o.creation_date, 'fmMonth DDfm, YYYY') as creation_date_pretty,
           u.first_names as creation_user_first_names,
           u.last_name as creation_user_last_name
    from   bookshelf_books b join 
           acs_objects o on (o.object_id = b.book_id) join
           cc_users u on (u.user_id = o.creation_user)
    where  [join $where_clauses " and "]
    order  by o.creation_date desc
"

db_multirow -extend { view_url edit_url } book books $sql {
    if { [empty_string_p $excerpt] } {
        set excerpt [string_truncate -len 300 -- $main_entry]
    }
    set read_status_pretty [string totitle $read_status_pretty]
    set view_url "book-view?[export_vars { book_no }]"
    set edit_url "book-edit?[export_vars { book_no }]"
}

db_multirow -extend { name_url stat_name } stats stats_by_read_status {
    select b.read_status as unique_id,
           bookshelf_book__read_status_pretty(b.read_status) as name,
           count(b.book_id) as num_books
    from   bookshelf_books b
    where  b.package_id = :package_id
    group  by unique_id
    order  by bookshelf_book__read_status_sort_order(b.read_status)
} {
    set stat_name "Read status"
    set name [string totitle $name]
    set name_url ".?[export_vars -url { { read_status $unique_id } }]"
}

db_multirow -extend { name_url stat_name } -append stats stats_by_publish_status {
    select b.publish_status as unique_id,
           bookshelf_book__pub_status_pretty(b.publish_status) as name,
           count(b.book_id) as num_books
    from   bookshelf_books b
    where  b.package_id = :package_id
    group  by unique_id
    order  by bookshelf_book__pub_status_sort_order(b.publish_status)
} {
    set stat_name "Publish status"
    set name [string totitle $name]
    set name_url ".?[export_vars -url { { publish_status $unique_id } }]"
}

db_multirow -extend { name_url stat_name } -append stats stats_by_reviewer {
    select o.creation_user as unique_id,
           u.first_names || ' ' || u.last_name as name,
           count(b.book_id) as num_books
    from   bookshelf_books b join
           acs_objects o on (o.object_id = b.book_id) join
           cc_users u on (u.user_id = o.creation_user)
    where  b.package_id = :package_id
    group  by unique_id, name
    order  by name
} {
    set stat_name "Reviewed By"
    set name_url ".?[export_vars -url { { creation_user $unique_id } }]"
}
