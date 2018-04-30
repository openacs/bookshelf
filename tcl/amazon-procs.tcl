ad_library {

    Bookshelf Library - Amazon integration

    @creation-date 2002-09-08
    @author Lars Pind (lars@pinds.com)
    @cvs-id $Id$

}

namespace eval bookshelf::amazon {

    ad_proc get_image_url {
        isbn
    } {
        return "http://images.amazon.com/images/P/$isbn.01.MZZZZZZZ.gif"
    }

    ad_proc get_book_url {
        {-associate_id "pindsdotcom"}
        isbn
    } {
        set url "http://www.amazon.com/exec/obidos/ASIN/$isbn"
        if { ![empty_string_p $associate_id] } {
            append url "/ref=nosim/$associate_id"
        }
        return $url
    }

    ad_proc get_image_info {
        -array:required
        isbn
    } {
        Find title, author, along with image_width and image_height
        for the cover thumbnail.
    } {
        # Select the info into the upvar'ed Tcl Array
        upvar $array row

        # Download image to temp file

        set filename "[ns_mktemp "/tmp/gifXXXXXX"].gif"
        set url [get_image_url $isbn]
        set httpopen_result [ns_httpopen GET $url]

        lassign $httpopen_result readfd writefd
        close $writefd

        set tmpfilefd [open $filename w]
        fconfigure $tmpfilefd -translation binary

        fcopy $readfd $tmpfilefd

        close $tmpfilefd
        close $readfd

        # Figure out the size

        # Hmm. it's actually a JPEG, though it's named GIF
        if { [catch {
            set gifsize [ns_jpegsize $filename]
        }] } {
            # Oops, and then sometimes it *is* a GIF ...
            set gifsize [ns_gifsize $filename]
        }

        # Delete tmp file
        file delete $filename


        set row(image_width) [lindex $gifsize 0]
        set row(image_height) [lindex $gifsize 1]
    }

    ad_proc get_book_info {
        -array:required
        isbn
    } {
        Find title and author from Amazon.
        for the cover thumbnail.
    } {
        # Select the info into the upvar'ed Tcl Array
        upvar $array row

        # Grab book info page from Amazon

        set url [get_book_url $isbn]

        set amazon_info_page [ns_httpget $url]

        if { ![regexp {<title>\s*Amazon.com: [^:]+: ([^<]*)\s*</title>} $amazon_info_page match title] } {
            set row(book_title) "-"
        } else {
            set row(book_title) [string trim $title]
        }


        if { ![regexp {by <a href="/exec/obidos/search-handle-url/index=books&field-author=[^"]*">([^<]+)</a>} $amazon_info_page match author] } {
            set row(book_author) "-"
        } else {
            set row(book_author) [string trim $author]
        }

    }
}
