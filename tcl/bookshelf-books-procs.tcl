ad_library {

    Bookshelf Library - for Books

    @creation-date 2002-09-08
    @author Lars Pind (lars@pinds.com)
    @cvs-id $Id$

}

namespace eval bookshelf::book {

    ad_proc -public new {
        {-package_id ""}
        {-book_id ""}
        {-isbn ""}
        {-book_author ""}
        {-book_title:required}
        {-main_entry ""}
        {-additional_entry ""}
        {-excerpt ""}
        {-publish_status ""}
        {-read_status ""}
        {-user_id ""}
    } {
        Create a new book.
    } {
        # Default values
        if { [empty_string_p $user_id] } {
            set user_id [ad_conn user_id]
        }
        if { [empty_string_p $package_id] } {
            set package_id [ad_conn package_id]
        }

        # Prepare the variables for instantiation
        set extra_vars [ns_set create]
        oacs_util::vars_to_ns_set -ns_set $extra_vars -var_list {package_id book_id isbn book_author book_title main_entry additional_entry excerpt publish_status read_status user_id}

        set book_id [package_instantiate_object -extra_vars $extra_vars bookshelf_book]

        return $book_id
    }
    
    ad_proc -public edit {
        {-book_id}
        {-book_no}
        {-book_package_id}
        {-isbn ""}
        {-book_author ""}
        {-book_title:required}
        {-main_entry ""}
        {-additional_entry ""}
        {-excerpt ""}
        {-publish_status ""}
        {-read_status ""}
    } {
        Editing a book.
    } {
        if { [exists_and_not_null book_id] } {
            db_dml update_book_by_id {
                update bookshelf_books
                set    isbn = :isbn,
                       book_author = :book_author,
                       book_title = :book_title,
                       main_entry = :main_entry,
                       additional_entry = :additional_entry,
                       excerpt = :excerpt,
                       publish_status = :publish_status,
                       read_status = :read_status
                where  book_id = :book_id
            }
        } else {
            if { ![exists_and_not_null book_no]} {
                error "You must supply either book_id or book_no"
            }
            if { ![exists_and_not_null package_id] } {
                set package_id [ad_conn package_id]
            }
            db_dml update_book_by_no {
                update bookshelf_books
                set    isbn = :isbn,
                       book_author = :book_author,
                       book_title = :book_title,
                       main_entry = :main_entry,
                       additional_entry = :additional_entry,
                       excerpt = :excerpt,
                       publish_status = :publish_status,
                       read_status = :read_status
                where  book_no = :book_no
                and    package_id = :package_id
            }
        }

    }

    ad_proc -public publish {
        {-book_id}
        {-book_no}
        {-package_id}
        {-publish_status "publish"}
    } {
        Publishing a book.
    } {
        if { [exists_and_not_null book_id] } {
            db_dml publish_book_by_id {
                update bookshelf_books
                set    publish_status = :publish_status
                where  book_id = :book_id
            }
        } else {
            if { ![exists_and_not_null book_no]} {
                error "You must supply either book_id or book_no"
            }
            if { ![exists_and_not_null package_id] } {
                set package_id [ad_conn package_id]
            }
            db_dml publish_book_by_no {
                update bookshelf_books
                set    publish_status = :publish_status
                where  book_no = :book_no
                and    package_id = :package_id
            }
        }
    }

    ad_proc -public get {
        {-book_id ""}
        {-book_no ""}
        {-package_id ""}
        {-array:required}
    } {
        Get the fields for a book
    } {
        # Select the info into the upvar'ed Tcl Array
        upvar $array row

        if { [exists_and_not_null book_id] } {
            db_1row select_book_by_id {
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
                       o.creation_user,
                       u.first_names as creation_user_first_names,
                       u.last_name as creation_user_last_name,
                       o.creation_date,
                       to_char(o.creation_date, 'fmMonth DDfm, YYYY') as creation_date_pretty
                from   bookshelf_books b join 
                       acs_objects o on (o.object_id = b.book_id) join
                       cc_users u on (u.user_id = o.creation_user)
                where  book_id = :book_id
            } -column_array row
        } else {
            if { ![exists_and_not_null book_no]} {
                error "You must supply either book_id or book_no"
            }
            if { ![exists_and_not_null package_id] } {
                set package_id [ad_conn package_id] 
            }
            db_1row select_book_by_no {
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
                       o.creation_user,
                       u.first_names as creation_user_first_names,
                       u.last_name as creation_user_last_name,
                       o.creation_date,
                       to_char(o.creation_date, 'fmMonth DDfm, YYYY') as creation_date_pretty
                from   bookshelf_books b join 
                       acs_objects o on (o.object_id = b.book_id) join
                       cc_users u on (u.user_id = o.creation_user)
                where  book_no = :book_no
                and    b.package_id = :package_id
            } -column_array row
        }
    }


}
