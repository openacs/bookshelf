# Nav bar, to be included on all pages

set package_id [ad_conn package_id]
set package_url [ad_conn package_url]

if { ![ad_permission_p $package_id create] && ![ad_permission_p $package_id write] && ![ad_permission_p $package_id admin] } {
    set show_navbar_p 0
} else {
    set show_navbar_p 1
}

multirow create links name url

multirow append links "List" [ad_conn package_url]

if { [ad_permission_p $package_id create] } {
    multirow append links "New Book" "[ad_conn package_url]book-edit"
}

if { [ad_conn user_id] != 0 } {
    multirow append links "My Books" "[ad_conn package_url]?[export_vars -url { { creation_user {[ad_conn user_id]} } }]"
}
if { [ad_permission_p $package_id admin] } {
    multirow append links "Admin" "[ad_conn package_url]admin/"
}

ad_return_template
