ad_library {
    Bookshelf install callbacks

    @creation-date 2004-05-20

    @author Jeff Davis davis@xarg.net
    @cvs-id $Id$
}

namespace eval bookshelf::install {}

ad_proc -private bookshelf::install::package_install {} { 
    package install callback
} {
    bookshelf::book::search::register_implementations
}

ad_proc -private bookshelf::install::package_uninstall {} { 
    package uninstall callback
} {
    bookshelf::book::search::unregister_implementations
}

ad_proc -private bookshelf::install::package_upgrade {
    {-from_version_name:required}
    {-to_version_name:required}
} {
    Package before-upgrade callback
} {
    apm_upgrade_logic \
        -from_version_name $from_version_name \
        -to_version_name $to_version_name \
        -spec {
            0.4d1 0.4d2 {
                # just need to install the bookshelf_bookshelf callback
                bookshelf::book::search::register_implementations
            }
        }
}
